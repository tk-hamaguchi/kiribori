require 'kiribori'

run Proc.new { |env|
  [
    '200',
    { 'Content-Type' => 'application/x-thor-template' },
    [Kiribori::CLI.execute!(%w[-a])]
  ]
}
