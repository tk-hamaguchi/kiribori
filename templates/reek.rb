# Kiribori Template for reek
context = <<EOM
  * コードスメルのチェック用にreekを追加
EOM


## Add gems

gem_group :development, :test do
  gem 'reek'
end

bundle_command 'install --quiet'


## Configuration for reek

create_file '.reek.yml', <<'CODE'
detectors:
  IrresponsibleModule:
    enabled: false
exclude_paths:
  - features
  - db
CODE


git add: %w[
  Gemfile
  Gemfile.lock
  .reek.yml
].join(' ')

git commit: "-m 'Apply reek template by Kiribori.\n#{context}'"
