# Kiribori Template for nginx
context = <<EOM
  * SSL確認用にnginxのコンテナを追加
EOM


## Configuration for nginx

create_file 'Dockerfile.nginx', <<'CODE'.strip
FROM nginx:latest

ARG VIRTUAL_HOST="localhost"
ENV VIRTUAL_HOST ${VIRTUAL_HOST}

ARG APP_HOST="http://app:3000"
ENV APP_HOST ${APP_HOST}

RUN mkdir -p /etc/nginx/certs

RUN apt-get update -qq && \
    apt-get install -y -qq openssl ssl-cert && \
    apt-get clean -qq && \
    rm -rf /var/lib/apt/lists/*

RUN echo "server {\n\tlisten 443 ssl;\n\tserver_name _;\n\tssl_certificate certs/ssl.pem;\n\tssl_certificate_key certs/ssl.key;\n\tlocation / {\n\t\tproxy_set_header X-Forwarded-Proto \$scheme;\n\t\tproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n\t\tproxy_set_header Host \$http_host;\n\t\tproxy_set_header X-Real-IP \$remote_addr;\n\t\tproxy_redirect off;\n\t\tproxy_pass ${APP_HOST};\n\t}\n}\n" > /etc/nginx/conf.d/default.conf

RUN openssl req -batch -new -x509 -newkey rsa:2048 -nodes -sha256 \
      -subj /CN=${VIRTUAL_HOST} -days 3650 \
      -keyout /etc/nginx/certs/ssl.key \
      -out /etc/nginx/certs/ssl.pem
CODE


insert_into_file 'docker-compose.yml', <<CODE, after: /^services:$/

  web:
    build:
      context: .
      dockerfile: Dockerfile.nginx
      #args:
      #  VIRTUAL_HOST: localhost
      #  APP_HOST:     http://app:3000
    ports:
      - 443:443
    depends_on:
      - app
CODE


git add: %w[
  Dockerfile.nginx
  docker-compose.yml
].join(' ')

git commit: "-m 'Apply nginx template by Kiribori.\n#{context}'"
