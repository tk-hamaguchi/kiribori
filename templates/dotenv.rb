# Kiribori Template for Dotenv
context = <<EOM
  * 環境変数を設定するために `dotenv-rails` を追加
EOM


## Add gems

gem 'dotenv-rails'

bundle_command 'install --quiet'
bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines"'


## Configuration for doteenv

append_to_file '.gitignore', ".env\n"

create_file '.env'
create_file '.env.example'


git add: %w[
  .gitignore
  Gemfile
  Gemfile.lock
  .env.example
].join(' ')

git commit: "-m 'Apply dotenv template by Kiribori.\n#{context}'"
