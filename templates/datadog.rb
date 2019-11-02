# Kiribori Template for datadog
context = <<EOM
  * エラーレポート用にDataDogを設定
EOM


## Add gems
gem 'ddtrace'

bundle_command 'install --quiet'


## Configuration for DataDog

create_file 'config/initializers/ddtrace.rb', <<'CODE'.strip
if ENV['DD_AGENT_HOST']
  Datadog.configure do |c|
    c.use :rails
  end
end
CODE


git add: %w[
  Gemfile
  Gemfile.lock
  config/initializers/ddtrace.rb
].join(' ')

git commit: "-m 'Apply datadog template by Kiribori.\n#{context}'"
