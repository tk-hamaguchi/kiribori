# Kiribori Template for annotate
context = <<EOM
  * DB情報の認識をしやすくするため `annotate` を導入
EOM

## Add gems

gem_group :development, :test do
  gem 'annotate'
end

bundle_command 'install --quiet'


## Configuration for annotate

generate 'annotate:install'


bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Style/FrozenStringLiteralComment,Layout/AlignHash,Style/BracesAroundHashParameters,Style/TrailingCommaInHashLiteral"'


git add: %w[
  Gemfile
  Gemfile.lock
  lib/tasks/auto_annotate_models.rake
].join(' ')

git commit: "-m 'Apply annotate template by Kiribori.\n#{context}'"
