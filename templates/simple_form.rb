# Kiribori Template for SimpleForm
context = <<EOM
  * formの記述性を高めるために `simple_form` を導入
EOM


## Add gems

gem 'simple_form'

bundle_command 'install --quiet'
bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines"'


## Configure for SimpleForm

generate 'simple_form:install', '--bootstrap'


git add: %w[
  Gemfile
  Gemfile.lock
  config/initializers/simple_form.rb
  config/initializers/simple_form_bootstrap.rb
  config/locales/simple_form.en.yml
  lib/templates/haml/scaffold/_form.html.haml
].join(' ')

git commit: "-m 'Apply simple_form template by Kiribori.\n#{context}'"

