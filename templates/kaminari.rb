# Kiribori Template for kaminari
context = <<EOM
  * ページング処理を実現するために `kaminari` を追加
EOM

## Add gems

gem 'kaminari'

bundle_command 'install --quiet'
bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines"'


## Configuration for config

generate 'kaminari:config'
generate 'kaminari:views bootstrap4'


git add: %w[
  Gemfile
  Gemfile.lock
  app/views/kaminari/_first_page.html.haml
  app/views/kaminari/_gap.html.haml
  app/views/kaminari/_last_page.html.haml
  app/views/kaminari/_next_page.html.haml
  app/views/kaminari/_page.html.haml
  app/views/kaminari/_paginator.html.haml
  app/views/kaminari/_prev_page.html.haml
  config/initializers/kaminari_config.rb
].join(' ')

git commit: "-m 'Apply kaminari template by Kiribori.\n#{context}'"
