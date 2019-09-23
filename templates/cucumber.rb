# Kiribori Template for cucumber
context = <<EOM
  * システムテスト用ツールとしてcucumberを導入
EOM


## Add gems

gem_group :development, :test do
  gem 'cucumber-rails', require: false
  gem 'webdrivers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'aruba'
end

bundle_command 'install --quiet'


## Configuration for cucumber

generate 'cucumber:install'

create_file 'features/support/capybara.rb', <<'EOS'
require 'capybara/cucumber'
require 'webdrivers'

Capybara.configure do |config|
  config.default_driver    = :selenium_chrome_headless
  config.javascript_driver = :selenium_chrome_headless
end
EOS

create_file 'features/support/aruba.rb', <<'EOS'
require 'aruba/cucumber'
EOS

create_file 'features/step_definitions/browser_steps.rb', <<'EOS'
When("ブラウザのウィンドウを {int}px × {int}px にリサイズする") do |width, height|
  page.driver.browser.manage.window.resize_to(width, height)
end

Then("スクリーンショットを撮って{string}に保存する") do |file_path|
  page.save_screenshot "tmp/#{file_path}"
end
EOS

create_file 'features/step_definitions/cli_steps.rb', <<'EOS'
When("下記のコマンドを実行する:") do |command|
  cmd = sanitize_text(command)
  run_command_and_stop(cmd, fail_on_error: false)
end

Then("{string}に下記の内容が表示されている:") do |output_type, expected|
  output_string_matcher = :an_output_string_including
  expect(last_command_started).to send(output_to_matcher(output_type), send(output_string_matcher, expected))
end

Then("{string}に何も表示されていない") do |output_type|
  expect(last_command_started).to send(output_to_matcher(output_type), send(:an_output_string_being_eq, ''))
end
EOS

create_file 'features/support/name_resolver.rb', <<'EOS'
# シナリオの表記名を変換するモジュール
module NameResolver
  def output_to_matcher(output)
    case output
    when '標準出力', 'stdout', 'STDOUT' then :have_output_on_stdout
    when '標準エラー出力', 'stderr', 'STDERR' then :have_output_on_stderr
    else
      :have_output
    end
  end
end

World NameResolver
EOS

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct'


git add: %w[
  Gemfile
  Gemfile.lock
  config/cucumber.yml
  features/step_definitions/.gitkeep
  features/step_definitions/browser_steps.rb
  features/step_definitions/cli_steps.rb
  features/support/aruba.rb
  features/support/capybara.rb
  features/support/env.rb
  features/support/name_resolver.rb
  lib/tasks/cucumber.rake
  script/cucumber
].join(' ')

git commit: "-m 'Apply cucumber template by Kiribori.\n#{context}'"
