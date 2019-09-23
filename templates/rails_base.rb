# Kiribori Template for RailsBase
context = <<EOM
  * スワップファイルがリポジトリに紛れ込まないよう `.gitignore` に `*.swp` を追加
  * 個人のDB接続情報がリポジトリに混入しないよう `config/database.yml` をリポジトリから排除。代替として `config/database.yml.example` を追加
  * タイムゾーンと、デフォルトの辞書を日本・東京に準拠するよう変更
  * パスワードハッシュ化関数として `bcrypt` を取り込み
  * Windowsでの実行は想定しないため、 `tzinfo-data` を除外
  * I18n化のため `rails-i18n` を追加し、辞書ファイルを拡充
  * `i18n`のフォールバック先を `[I18n.default_locale]` に修正
EOM

append_to_file '.gitignore', "*.swp\n"

## Copy database.yml to .example and add .gitigrore
database_yml_src = 'config/database.yml'
database_yml_dst = database_yml_src + '.example'
copy_file database_yml_src, database_yml_dst unless File.exist?(database_yml_dst)
append_to_file '.gitignore', "#{database_yml_src}\n"
git rm: database_yml_src + ' --cached'

## Set timezone and default locale to application.rb
environment <<-'EOT'
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

EOT

## Purge tzinfo-data and merge bcrypt
uncomment_lines 'Gemfile', /gem 'bcrypt'/
comment_lines   'Gemfile', /gem 'tzinfo-data'/

## Add rails-i18n to Gemfile
gem 'rails-i18n'

bundle_command 'install --quiet'

gsub_file 'config/environments/production.rb', /^(\s*config\.i18n\.fallbacks =)\s*.*$/, '\1 [I18n.default_locale]'

git add: %w[
  .gitignore
  Gemfile
  Gemfile.lock
  config/application.rb
  config/environments/production.rb
  config/database.yml.example
].join(' ')

git commit: "-m 'Apply rails_base template by Kiribori.\n#{context}'"
