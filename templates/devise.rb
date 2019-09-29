# Kiribori Template for devise
context = <<EOM
  * 認証用にDevieseを導入
EOM

## Add gems

gem 'devise'
gem 'devise-i18n'

bundle_command 'install --quiet'


## Install and setup Devise

generate 'devise:install'
gsub_file 'config/initializers/devise.rb', /^( +)# config\.timeout_in = .+$/,     '\1config.timeout_in = 30.minutes'
gsub_file 'config/initializers/devise.rb', /^( +)# config\.remember_for = .+$/,   '\1config.remember_for = 2.weeks'
gsub_file 'config/initializers/devise.rb', /^( +)# (config\.secret_key = '.+')$/, '\1\2'

create_file 'spec/support/devise.rb', <<'CODE'
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
end
CODE


## Configuration for Controller and Helper

### Add Devise User's helper

generate :helper, 'devise_user_login'
prepend_to_file 'app/helpers/devise_user_login_helper.rb', "# DeviseUserLoginHelper\n"

inject_into_module 'app/helpers/devise_user_login_helper.rb', 'DeviseUserLoginHelper', <<'CODE'

  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  def resource_name
    :user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:username, :email, :password, :password_confirmation)
    end
  end
CODE


### Add Devise User's views

remove_file 'config/locales/devise.en.yml'
generate 'devise:i18n:locale', 'ja'
gsub_file 'config/locales/devise.views.ja.yml', /^(\s+devise:)$/, '\1 &default'
insert_into_file 'config/locales/devise.views.ja.yml', "        username: ログインID\n", after: "email: Eメール\n"

generate 'devise:i18n:views', 'User'

insert_into_file 'app/views/users/registrations/new.html.erb', <<CODE, after: "input_html: { autocomplete: \"email\" }%>\n"
    <%= f.input :username,
                required:   true,
                input_html: { autocomplete: "username" }%>
CODE


### Configuration for Devise User's Registrations

generate :controller, 'users/registrations', '--skip-routes', '--no-helper', '--no-stylesheets'
prepend_to_file 'app/controllers/users/registrations_controller.rb', "# Users::RegistrationsController\n"
append_to_file 'config/locales/devise.views.ja.yml', "\n  users:\n    <<: *default\n"

gsub_file 'app/controllers/users/registrations_controller.rb', 'ApplicationController',  'Devise::RegistrationsController'

inject_into_class 'app/controllers/users/registrations_controller.rb', 'Users::RegistrationsController', <<EOS
  include DeviseUserLoginHelper
  before_action :configure_permitted_parameters
EOS

insert_into_file 'spec/controllers/users/registrations_controller_spec.rb', "\n  pending", after: /^RSpec.describe Users::RegistrationsController, type: :controller do$/


### Configuration for Devise User's Passwords

generate :controller, 'users/passwords', '--skip-routes', '--no-helper', '--no-stylesheets'
prepend_to_file 'app/controllers/users/passwords_controller.rb', "# Users::PasswordsController\n"
gsub_file 'app/controllers/users/passwords_controller.rb', 'ApplicationController',  'Devise::PasswordsController'

inject_into_class 'app/controllers/users/passwords_controller.rb', 'Users::PasswordsController', <<EOS
  include DeviseUserLoginHelper
EOS

insert_into_file 'spec/controllers/users/passwords_controller_spec.rb', "\n  pending", after: /^RSpec.describe Users::PasswordsController, type: :controller do$/


### Configuration for Devise User's Sessions

generate :controller, 'users/sessions', '--skip-routes', '--no-helper', '--no-stylesheets'
prepend_to_file 'app/controllers/users/sessions_controller.rb', "# Users::SessionsController\n"
gsub_file 'app/controllers/users/sessions_controller.rb', 'ApplicationController',  'Devise::SessionsController'

inject_into_class 'app/controllers/users/sessions_controller.rb', 'Users::SessionsController', <<EOS
  include DeviseUserLoginHelper
EOS

insert_into_file 'spec/controllers/users/sessions_controller_spec.rb', "\n  pending", after: /^RSpec.describe Users::SessionsController, type: :controller do$/


## Add and Configuration for Devise's User model

generate :devise, 'User', 'username:string', 'lock_version:integer', 'deleted_at:timestamp'
prepend_to_file 'app/models/user.rb', "# User\n"

inject_into_class 'app/models/user.rb', 'User', <<CODE

  ### associations

  ### callbacks

  ### validations

  validates :username,
            presence: true,
            length:   { in: 2..40 }

  validates :email,
            presence:   true,
            uniqueness: { case_sensitive: false }

  validates :password,
            presence:     true,
            confirmation: true,
            length:       { minimum: 8, maximum: 120 },
            on:           :create

  validates :password,
            confirmation: true,
            length:       { minimum: 8, maximum: 120 },
            on:           :update,
            allow_blank:  true

  ### mix-in

CODE

insert_into_file 'app/models/user.rb', "\n  ### methods\n\n", before: /^end$/


gsub_file 'spec/models/user_spec.rb', /^.*pending.*$/, <<CODE

  context 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(2).is_at_most(40) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(120) }
  end
CODE

insert_into_file 'spec/factories/users.rb', <<CODE.rstrip, after: "factory :user do\n"
    username { Faker::Internet.username }
    email    { Faker::Internet.email }
    password { 'P@ssw0rd' }
CODE

gsub_file 'app/models/user.rb', /(:registerable,)/, '\1 :timeoutable,'
 

### Add routing

gsub_file 'config/routes.rb', /^(\s*devise_for\s+:[^,\s]+)(?:,[\s\n]*controllers:\s*\{[^\}]+\})?\n/m, <<~'EOS'

  \1,
               controllers: {
                 sessions:      'users/sessions',
                 registrations: 'users/registrations',
                 passwords:     'users/passwords'
               }

EOS


## Add Home page and My pages

generate :controller, 'my', 'top', '--skip-routes'
inject_into_class 'app/controllers/my_controller.rb', 'MyController', "  include DeviseUserLoginHelper\n\n  before_action :authenticate_user!\n"
prepend_to_file 'app/controllers/my_controller.rb', "# MyController\n"
prepend_to_file 'app/helpers/my_helper.rb', "# MyHelper\n"
append_to_file 'app/views/my/top.html.haml', "\n%hr\n= link_to destroy_user_session_path, method: :delete do\n  = t('sign_out')\n"
insert_into_file 'spec/controllers/my_controller_spec.rb', "\n      pending", after: /^    it "returns http success" do$/

generate :controller, 'home', 'index', '--skip-routes'
prepend_to_file 'app/controllers/home_controller.rb', "# HomeController\n"
insert_into_file 'app/controllers/home_controller.rb', "    redirect_to my_top_path if user_signed_in?\n", after: "def index\n"
prepend_to_file 'app/helpers/home_helper.rb', "# HomeHelper\n"
append_to_file 'app/views/home/index.html.haml', "\n%hr\n= render 'devise/shared/links'\n"
insert_into_file 'spec/controllers/home_controller_spec.rb', "\n      pending", after: /^    it "returns http success" do$/

route <<EOS

  namespace :my do
    get 'top'
  end

  root to: 'home#index'
EOS

rails_command 'haml:erb2haml'

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines,Style/FrozenStringLiteralComment,Style/StringLiterals,Style/EmptyMethod,Layout/TrailingWhitespace,Layout/EmptyLines"'

git add: %w[
  Gemfile
  Gemfile.lock
  config/routes.rb
  app/assets/stylesheets/my.scss
  app/controllers/my_controller.rb
  app/helpers/my_helper.rb
  app/models/user.rb
  app/views/my/top.html.haml
  config/initializers/devise.rb
  db/migrate/*_devise_create_users.rb
  spec/controllers/my_controller_spec.rb
  spec/factories/users.rb
  spec/support/devise.rb
  spec/helpers/my_helper_spec.rb
  spec/models/user_spec.rb
  spec/views/my/top.html.haml_spec.rb
  app/assets/stylesheets/home.scss
  app/controllers/home_controller.rb
  app/controllers/users/passwords_controller.rb
  app/controllers/users/registrations_controller.rb
  app/controllers/users/sessions_controller.rb
  app/helpers/devise_user_login_helper.rb
  app/helpers/home_helper.rb
  app/views/home/index.html.haml
  spec/controllers/home_controller_spec.rb
  spec/controllers/users/passwords_controller_spec.rb
  spec/controllers/users/registrations_controller_spec.rb
  spec/controllers/users/sessions_controller_spec.rb
  spec/helpers/devise_user_login_helper_spec.rb
  spec/helpers/home_helper_spec.rb
  spec/views/home/index.html.haml_spec.rb
  config/locales/devise.views.ja.yml
  app/views/users/confirmations/new.html.haml
  app/views/users/mailer/confirmation_instructions.html.haml
  app/views/users/mailer/email_changed.html.haml
  app/views/users/mailer/password_change.html.haml
  app/views/users/mailer/reset_password_instructions.html.haml
  app/views/users/mailer/unlock_instructions.html.haml
  app/views/users/passwords/edit.html.haml
  app/views/users/passwords/new.html.haml
  app/views/users/registrations/edit.html.haml
  app/views/users/registrations/new.html.haml
  app/views/users/sessions/new.html.haml
  app/views/users/shared/_error_messages.html.haml
  app/views/users/shared/_links.html.haml
  app/views/users/unlocks/new.html.haml
].join(' ')

git commit: "-m 'Apply devise template by Kiribori.\n#{context}'"
