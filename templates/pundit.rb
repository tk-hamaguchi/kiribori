# Kiribori Template for pundit
context = <<EOM
  * 認可処理のため `pundit` を追加
EOM

## Add gems

gem 'pundit'

bundle_command 'install --quiet'


## Configuration for config

generate 'pundit:install'
create_file 'spec/support/pundit.rb', "require 'pundit/rspec'"

inject_into_class 'app/controllers/my_controller.rb', 'MyController', "  include Pundit\n"


insert_into_file 'app/policies/application_policy.rb', "# ApplicationPolicy\n", before: /^class ApplicationPolicy$/
insert_into_file 'app/policies/application_policy.rb', "  # ApplicationPolicy::Scope\n", before: /^  class Scope$/

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines,Layout/EmptyLines,Style/FrozenStringLiteralComment"'


git add: %w[
  Gemfile
  Gemfile.lock
  app/controllers/my_controller.rb
  app/policies/application_policy.rb
	spec/support/pundit.rb
].join(' ')

git commit: "-m 'Apply pundit template by Kiribori.\n#{context}'"
