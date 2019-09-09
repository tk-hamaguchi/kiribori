# Kiribori Template for HAML
context = <<EOM
  * viewファイルの記述性を高めるために `haml-rails` を導入
EOM

gem 'haml-rails'

append_to_file '.env', "HAML_RAILS_DELETE_ERB=true\n"
remove_file '.env.example'
copy_file '.env', '.env.example'

run_bundle

rails_command 'haml:erb2haml'

git add: %w[
  Gemfile
  Gemfile.lock
  .env.example
  app/views/layouts/application.html.haml
].join(' '),
    rm: 'app/views/layouts/application.html.erb'

git commit: "-m 'Apply haml-rails template by Kiribori.\n#{context}'"

