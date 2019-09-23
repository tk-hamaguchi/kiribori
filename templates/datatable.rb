# Kiribori Template for datatable
context = <<EOM
  * 表の表示用として`ajax-datatable`を採用
EOM

## Install node packages
run 'yarn add datatables.net-bs4 datatables.net-rowgroup-bs4 imports-loader'


## Add gems

gem 'ajax-datatables-rails'
gem 'draper'

bundle_command 'install --quiet'


## Add commons

append_to_file 'app/javascript/packs/application.js', <<EOS

require( 'datatables.net-bs4' )();
require( 'datatables.net-rowgroup-bs4' )();
EOS


generate 'draper:install'
prepend_to_file 'app/decorators/application_decorator.rb', "# ApplicationDecorator\n"


generate 'datatable:config'


insert_into_file 'config/webpack/environment.js', <<CODE, before: /^module\.exports = environment$/


const webpack = require('webpack');
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/dist/jquery',
    jQuery: 'jquery/dist/jquery',
    Popper: 'popper.js/dist/popper'
  })
)

const datatables = require('./loaders/datatables')
environment.loaders.append('datatables', datatables)

CODE

create_file 'config/webpack/loaders/datatables.js', <<CODE
module.exports = {
  test: /datatables\.net.*/,
  loader: 'imports-loader?define=>false'
}
CODE


bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines,Style/FrozenStringLiteralComment"'


git add: %W[
  Gemfile
  Gemfile.lock
  app/javascript/packs/application.js
  package.json
  yarn.lock
  app/decorators/application_decorator.rb
  config/initializers/ajax_datatables_rails.rb
  config/webpack/environment.js
  config/webpack/loaders/datatables.js
].join(' ')

git commit: "-m 'Apply datatable datatable by Kiribori.\n#{context}'"
