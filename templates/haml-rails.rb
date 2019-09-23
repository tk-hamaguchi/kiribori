# Kiribori Template for HAML
context = <<EOM
  * viewのテンプレートエンジンをERBからhamlに変更
EOM


## Add gems

gem 'haml-rails'

bundle_command 'install --quiet'
bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines"'


## Configuration for haml

append_to_file '.env', "HAML_RAILS_DELETE_ERB=true\n"
remove_file '.env.example'
copy_file '.env', '.env.example'

rails_command 'haml:erb2haml'


git add: %w[
  Gemfile
  Gemfile.lock
  .env.example
  app/views/layouts/application.html.haml
  app/views/layouts/mailer.html.haml
  app/views/layouts/mailer.text.haml
].join(' '),
    rm: %w[
      app/views/layouts/application.html.erb
      app/views/layouts/mailer.html.erb
      app/views/layouts/mailer.text.erb
    ].join(' ')

git commit: "-m 'Apply haml-rails template by Kiribori.\n#{context}'"
