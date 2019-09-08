# frozen_string_literal: true

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
