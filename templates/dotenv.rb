# Kiribori Template for Dotenv
context = <<EOM
  * 環境変数を設定するために `dotenv-rails` を追加
EOM

gem 'dotenv-rails'
append_to_file '.gitignore', ".env\n"

create_file '.env'
create_file '.env.example'

run_bundle

git add: %w[
  .gitignore
  Gemfile
  Gemfile.lock
  .env.example
].join(' ')

git commit: "-m 'Apply dotenv template by Kiribori.\n#{context}'"
