# Kiribori Template for CircleCI
context = <<EOM
  * CircleCIの設定を追加
EOM

empty_directory '.circleci'
create_file '.circleci/config.yml', <<'CODE'
version: 2.1

executors:
  default:
    docker:
      - image: circleci/ruby:2.6.5-node
    working_directory: ~/workspace
  full_package:
    docker:
      - image: circleci/ruby:2.6.5-node-browsers
        environment:
          RAILS_ENV: test
          DATABASE_URL: mysql2://root:@127.0.0.1:3306/circle_test?encoding=utf8mb4&prepared_statements=true
          REDIS_URL: redis://127.0.0.1:6379/2
          REDIS_URL_FOR_CACHE: redis://127.0.0.1:6379/1
          ELASTICSEARCH_URL: http://127.0.0.1:9200/
      - image: circleci/mysql:5.7
        environment:
          MYSQL_USER: root
          MYSQL_ALLOW_EMPTY_PASSWORD: yes
          MYSQL_DATABASE: circle_test
      - image: redis
      - image: docker.elastic.co/elasticsearch/elasticsearch:7.4.0
        environment:
          http.host: '0.0.0.0'
          http.port: 9200
          xpack.security.enabled: false
          discovery.type: 'single-node'
          ES_JAVA_OPTS: '-Xms512m -Xmx512m'
    working_directory: ~/workspace

commands:
  save_bundle_cache:
    steps:
      - save_cache:
          paths:
            - ./vendor/bundle
            - ./node_modules
          key: v1-dependencies-{{ checksum "Gemfile.lock" }}
  restore_bundle_cache:
    steps:
      - restore_cache:
          keys:
          - v1-dependencies-{{ checksum "Gemfile.lock" }}
          - v1-dependencies-

jobs:
  bundler:
    executor:
      name: default
    steps:
      - checkout
      - restore_bundle_cache
      - run: bundle install --jobs=4 --retry=3 --deployment
      - save_bundle_cache
  rubocop:
    executor:
      name: default
    steps:
      - checkout
      - restore_bundle_cache
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: bundle install --deployment
      - run:
          name: lint check
          command: |
            bundle exec rubocop -D -R  -c .rubocop.yml \
              -r $(bundle show rubocop-junit-formatter)/lib/rubocop/formatter/junit_formatter.rb \
              --format RuboCop::Formatter::JUnitFormatter --out /tmp/test-results/rubocop.xml \
              -f html -o /tmp/artifacts/rubocop.html \
              -fp
      - store_test_results:
          path: /tmp/test-results
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
  rspec:
    executor:
      name: full_package
    parallelism: 1
    steps:
      - checkout
      - restore_bundle_cache
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: bundle install --deployment
      - run: bundle exec rake assets:precompile db:setup
      - run:
          name: run tests
          command: |
            TEST_FILES="$(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)"
            bundle exec rspec \
              --format RspecJunitFormatter --out /tmp/test-results/rspec.xml \
              --format html --out /tmp/artifacts/rspec.html \
              --format progress \
              $TEST_FILES
            cp log/bullet.log /tmp/artifacts/
      - store_test_results:
          path: /tmp/test-results
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
      - store_artifacts:
          path: coverage
          destination: coverage
  rails_best_practices:
    executor:
      name: default
    parallelism: 1
    steps:
      - checkout
      - restore_bundle_cache
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: bundle install --deployment
      - run: bundle exec rails_best_practices --format=html --output-file=/tmp/artifacts/rails_best_practices.html .
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
  cucumber:
    executor:
      name: full_package
    parallelism: 1
    steps:
      - checkout
      - restore_bundle_cache
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: bundle install --deployment

      - run:
          name: Install System Dependencies
          command: |
            sudo apt-get update
            sudo apt-get install -y libappindicator1 fonts-liberation
            export CHROME_BIN=/usr/bin/google-chrome
            wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i google-chrome*.deb

      - run: bundle exec rake db:setup assets:precompile

      - run:
          name: run tests
          command: |
            TEST_FILES="$(circleci tests glob "features/**/*.feature" | circleci tests split --split-by=timings)"
            bundle exec cucumber \
              --format junit --out /tmp/test-results/cucumber.xml \
              --format html --out /tmp/artifacts/cucumber.html \
              --format progress \
              $TEST_FILES

      - store_test_results:
          path: /tmp/test-results

      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
  build_docs:
    executor:
      name: default
    steps:
      - checkout
      - run: mkdir -p html_book
      - persist_to_workspace:
          root: ~/workspace
          paths:
            - html_book
  rails_erd:
    executor:
      name: full_package
    parallelism: 1
    steps:
      - checkout
      - restore_bundle_cache
      - attach_workspace:
          at:  ~/workspace
      - run: sudo apt-get install graphviz
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: bundle install --deployment
      - run: bundle exec rake db:drop db:create db:migrate
      - run: mkdir -p html_book/images
      - run: bundle exec erd --attributes=foreign_keys,primary_keys,content,timestamp --filename=./html_book/images/erd --filetype=png
      - run: cp ./html_book/images/erd.png /tmp/artifacts/
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
      - persist_to_workspace:
          root: ~/workspace
          paths:
            - html_book/images
  gitbook:
    executor:
      name: default
    steps:
      - checkout
      - restore_bundle_cache
      - attach_workspace:
          at:  ~/workspace
      - run: sudo npm install gitbook-cli -g
      - run: mkdir /tmp/test-results /tmp/artifacts
      - run: gitbook build docs html_book
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts
      - persist_to_workspace:
          root: ~/workspace
          paths:
            - html_book
  deploy_docs:
    executor:
      name: default
    steps:
      - attach_workspace:
          at:  ~/workspace
      - run: mkdir /tmp/artifacts
      - run: cp -rf ./html_book /tmp/artifacts/
      - store_artifacts:
          path: /tmp/artifacts
          destination: artifacts

  build_docker_image:
    docker:
      - image: circleci/python:3.6

    working_directory: ~/circleci-working

    steps:
      - checkout

      - setup_remote_docker

      - run:
          name: Set Environment Variables
          command: |
            if [ -n "${CIRCLE_TAG}" ]; then
              echo 'export TAG=$CIRCLE_TAG' >> $BASH_ENV
            else
              echo 'export TAG=$(echo $CIRCLE_SHA1 | cut -c 1-7)' >> $BASH_ENV
            fi
      - run:
          name: Create BUILD_VERSION
          command: |
            echo "build${CIRCLE_BUILD_NUM} ($(echo $CIRCLE_SHA1 | cut -c 1-7))" > BUILD_VERSION
            echo ${CIRCLE_SHA1} > release_version
      - run:
          name: Build Docker image
          command: |
            BUILD_ARGS=''
            if [ -n "${RAILS_MASTER_KEY}" ]; then
              BUILD_ARGS="${BUILD_ARGS} --build-arg RAILS_MASTER_KEY=${RAILS_MASTER_KEY}"
            fi
            if [ -n "${BUNDLE_GEM__FURY__IO}" ]; then
              BUILD_ARGS="${BUILD_ARGS} --build-arg BUNDLE_GEM__FURY__IO=${BUNDLE_GEM__FURY__IO}"
            fi
            docker build ${BUILD_ARGS} -t ${REGISTRY_NAME}/${CIRCLE_PROJECT_REPONAME}:${TAG} .
      - run:
          name: Push Docker image
          command: |
            if echo ${REGISTRY_NAME} | fgrep '.' ; then
              docker login --username ${DOCKER_USER} --password ${DOCKER_PASS} ${REGISTRY_NAME}
            else
              docker login --username ${DOCKER_USER} --password ${DOCKER_PASS}
            fi
            docker push ${REGISTRY_NAME}/${CIRCLE_PROJECT_REPONAME}:${TAG}

workflows:
  build_and_test:
    jobs:
      - bundler
      - rubocop:
          requires:
            - bundler
      - rails_best_practices:
          requires:
            - bundler
      - rspec:
          requires:
            - rubocop
            - rails_best_practices
      - cucumber:
          requires:
            - rspec
      - build_docs:
          requires:
            - cucumber
          filters:
            branches:
              only:
                - master
                - develop
      - rails_erd:
          requires:
            - build_docs
      #- gitbook:
      #    requires:
      #      - build_docs
      - deploy_docs:
          requires:
            - rails_erd
            #- gitbook
      - build_docker_image:
          requires:
            - cucumber
          filters:
            branches:
              only:
                - master
                - develop
      - approve_deploy:
          type: approval
          requires:
            - build_docker_image


  tag_release:
    jobs:
      - build_docker_image:
          filters:
            branches:
              ignore: /.*/
            tags:
              only: /^[0-9]+(\.[0-9]+){2,}(\..+)?$/
CODE


git add: %w[
  .circleci/config.yml
].join(' ')

git commit: "-m 'Apply CircleCI template by Kiribori.\n#{context}'"
