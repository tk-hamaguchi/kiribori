# Kiribori Template for ERD
context = <<EOM
  * ER図生成用にrails-erdを追加
EOM


## Add gems

gem_group :development do
  gem 'rails-erd'
end

bundle_command 'install --quiet'


## Configuration for reek

generate 'erd:install'

create_file '.erdconfig', <<'CODE'
attributes:
  - content
  - foreign_key
  - inheritance
  - primary_keys
  - timestamp
disconnected: true
filename: erd
filetype: png
indirect: true
inheritance: false
markup: true
notation: simple
# orientation: horizontal
polymorphism: false
sort: true
warn: true
# title: sample title
exclude: null
only: null
only_recursion_depth: null
prepend_primary: false
cluster: false
splines: spline
CODE

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Style/FrozenStringLiteralComment,Style/IfUnlessModifier"'

git add: %w[
  Gemfile
  Gemfile.lock
  .erdconfig
  lib/tasks/auto_generate_diagram.rake
].join(' ')

git commit: "-m 'Apply erd template by Kiribori.\n#{context}'"
