# Kiribori Template for rubocop
context = <<EOM
  * コーディング規約チェックのため `rubocop` を導入
EOM


## Add gems

gem_group :development, :test do
  gem 'rubocop', '0.74.0'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-junit-formatter'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
end

bundle_command 'install --quiet'


## Configuration for rubocop

create_file '.rubocop.yml', <<CODE
require:
  - rubocop-performance
  - rubocop-rspec

AllCops:
  TargetRubyVersion: 2.6
  Exclude:
    - 'vendor/bundle/**/*'
    - 'node_modules/**/*'
    - 'bin/**/*'
    - 'config/**/*'
    - 'db/**/*'

Bundler/OrderedGems:
  Enabled: false

Layout/EmptyLinesAroundBlockBody:
  Enabled: false

Layout/EmptyLinesAroundClassBody:
  Enabled: false

Layout/EmptyLinesAroundModuleBody:
  Enabled: false


Layout/AlignHash:
  EnforcedHashRocketStyle: table
  EnforcedColonStyle: table

Lint/AmbiguousOperator:
  Exclude:
    - 'exe/**/*'

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'
    - 'lib/tasks/**/*'

Metrics/LineLength:
  Max: 120
  Exclude:
    - '*.gemspec'
    - 'lib/tasks/**/*'

Naming/AccessorMethodName:
  Exclude:
    - 'app/datatables/**/*'

Naming/FileName:
  Exclude:
    - 'spec/support/**/*'

RSpec/ContextWording:
  Enabled: false

RSpec/ExampleLength:
  Max: 20

RSpec/NestedGroups:
  Enabled: false

Style/AsciiComments:
  Enabled: false

Style/BlockComments:
  Exclude:
    - 'spec/spec_helper.rb'

Style/ClassAndModuleChildren:
  Enabled: false

Style/StringLiterals:
  Exclude:
    - 'features/step_definitions/**/*'
CODE


## Fix code with rubocop

prepend_to_file 'app/helpers/application_helper.rb', "# ApplicationHelper\n"
prepend_to_file 'app/mailers/application_mailer.rb', "# ApplicationMailer\n"
prepend_to_file 'app/models/application_record.rb', "# ApplicationRecord\n"

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Style/FrozenStringLiteralComment,Style/SymbolArray"'


git add: %w[
  Gemfile
  Gemfile.lock
  .rubocop.yml
  Rakefile
  app/controllers/application_controller.rb
  app/helpers/application_helper.rb
  app/jobs/application_job.rb
  app/mailers/application_mailer.rb
  app/models/application_record.rb
  config.ru
  db/seeds.rb
].join(' ')

git commit: "-m 'Apply rubocop template by Kiribori.\n#{context}'"
