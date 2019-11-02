# Kiribori Template for sentry
context = <<EOM
  * エラーレポート用にSentryを設定
EOM


## Add gems
gem 'sentry-raven'

bundle_command 'install --quiet'

git add: %w[
  Gemfile
  Gemfile.lock
].join(' ')

git commit: "-m 'Apply sentry template by Kiribori.\n#{context}'"
