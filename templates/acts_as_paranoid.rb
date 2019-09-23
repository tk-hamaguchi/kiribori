# Kiribori Template for acts_as_paranoid
context = <<EOM
  * 論理削除用に `acts_as_paranoid` を導入
EOM


## Add gems

gem 'acts_as_paranoid'
bundle_command 'install --quiet'


## Add configuration for User

insert_into_file 'app/models/user.rb', "\n\n  acts_as_paranoid", after: /^  ### mix-in$/

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines"'

git add: %w[
  Gemfile
  Gemfile.lock
  app/models/user.rb
].join(' ')

git commit: "-m 'Apply acts_as_paranoid template by Kiribori.\n#{context}'"
