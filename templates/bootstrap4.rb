# Kiribori Template for bootstrap4
context = <<EOM
  * デザインテーマとしてBootstrap4+Fontawesomeを適用
EOM

## Install node packages
run 'yarn add vue-turbolinks jquery popper.js bootstrap @fortawesome/fontawesome-free bootstrap-vue'


## Add commons

create_file "config/locales/#{app_name}.ja.yml", <<CODE
ja:
  app_name: #{app_name.camelize}
  copyright_html: "Copyright &copy; %{year} #{app_name.camelize} Project, All Rights Reserved."

  layouts:
    navbar:
      sign_in: 'ログイン'
      sign_up: '新規登録'
      sign_out: 'ログアウト'
      edit_user_registration: 'ユーザ設定'
CODE

create_file "lib/#{app_name}.rb", <<CODE
require '#{app_name}/version'
CODE

create_file "lib/#{app_name}/version.rb", <<CODE
# #{app_name.camelize}
module #{app_name.camelize}
  # VERSION
  VERSION = '0.1.0'
end
CODE

create_file "config/initializers/#{app_name}.rb", <<CODE
require '#{app_name}'
CODE


## Build Layouts

### Build application layout with components

remove_file 'app/views/layouts/application.html.haml'
create_file 'app/views/layouts/application.html.haml', <<EOS
!!!
%html{ lang: 'ja' }
  %head
    %meta{ http: { equiv: 'Content-Type' }, content: 'text/html; charset=UTF-8' }/
    %meta{ name: 'viewport', content: 'width=device-width, initial-scale=1, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no' }/
    %meta{ name: 'format-detection', content: 'telephone=no,address=no,email=no' }/
    %meta{ http: { equiv: 'x-ua-compatible' }, content: 'ie=edge' }/
    %title<
      = t 'app_name'
    = csrf_meta_tags
    = csp_meta_tag
    = stylesheet_link_tag 'application', 'data-turbolinks-track' => 'reload', media: 'all'
    = stylesheet_pack_tag 'application' # , 'data-turbolinks-track' => 'reload'
    = yield :stylesheet_links
    = javascript_pack_tag 'application' # , 'data-turbolinks-track' => 'reload'
    = yield :javascript_links

  %body
    = content_for?(:application_content) ? yield(:application_content) : yield
EOS

append_to_file 'app/javascript/packs/application.js', <<EOS

import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'
import '../src/application.scss'
EOS

empty_directory 'app/javascript/src'

create_file 'app/javascript/src/application.scss', <<EOS
// $primary: #428bca;
// $grid-columns:      12;
// $grid-gutter-width: 30px;
$grid-breakpoints: (
  xs: 0,     // Extra small screen / phone
  sm: 576px, // Small screen / phone
  md: 768px, // Medium screen / tablet
  lg: 992px, // Large screen / desktop
  xl: 1200px // Extra large screen / wide desktop
);

$container-max-widths: (
  sm: 540px,
  md: 720px,
  lg: 960px,
  xl: 1140px
);

@import '~bootstrap/scss/bootstrap';
@import '~@fortawesome/fontawesome-free/scss/fontawesome';

@import 'base';
@import 'center_middle_layout';
@import 'grid_system_layout';
EOS

create_file 'app/javascript/src/base.css.scss', <<CODE
html,body {
  height: 100%;
}

body {
  min-width: 320px;
}

#footer {
  width: 100%;
  margin: 0.4rem;
  text-align: center;
  font: {
    size: 0.6rem;
  }
  color: gray
}

.copylight {
  margin: 0px;
}

.version_no {
  float: right;
  margin: 0px;
}
CODE

create_file 'app/views/shared/_alerts.html.haml', <<'CODE'
- if notice
  .alert.alert-info#information_area
    = notice
- if resource&.errors && !resource.errors.empty?
  .alert.alert-danger#warning_area{role:'alert'}
    = devise_error_messages!
- elsif alert
  .alert.alert-danger#warning_area{role:'alert'}
    = alert
CODE


### Build Center-Middle layout with components

create_file 'app/views/layouts/center_middle.html.haml', <<CODE
- content_for :application_content do
  - unless defined?(header) && header == false
    #header
      = render partial: '/layouts/navbar'
  .center-middle-layout
    .center-middle-layout-wrapper
      .container
        = content_for?(:content) ? yield(:content) : yield
      .center-middle-layout-footer
        #footer
          = render partial: '/layouts/footer'

= render template: 'layouts/application', locals:{ header: header }
CODE

create_file 'app/javascript/src/center_middle_layout.css.scss', <<CODE
.center-middle-layout {
  height: 100%;
  display: table;
  min-height: 100%;
  width: 100%;
  .center-middle-layout-wrapper {
    vertical-align: middle;
    display: table-cell;
    .container {
      margin-right: auto;
      margin-left: auto;
      padding-left: 15px;
      padding-right: 15px;
    }
  }
  .center-middle-layout-footer {
    position: fixed;
    bottom: 0px;
    width: 100%;
    padding: 0px 1rem;
    #footer {
      width: 100%;
    }
  }
}

#header {
  position: fixed;
  top: 0px;
  width: 100%;
}
CODE

create_file 'app/views/layouts/_navbar.html.haml', <<CODE
%nav.navbar.navbar-expand-lg.navbar-dark.bg-dark
  = link_to t('app_name'), root_path, class:'navbar-brand'
  %button.navbar-toggler{ type: :button, data: { toggle: 'collapse', target: '#navbarSupportedContent' }, aria: { controls: 'navbarSupportedContent', expanded: 'false', label: 'Toggle navigation' } }
    %span.navbar-toggler-icon

  #navbarSupportedContent.collapse.navbar-collapse
    %ul.navbar-nav.ml-auto
      - if user_signed_in?
        %li.nav-item
          .dropdown.pull-xs-right
            %a.nav-link.dropdown-toggle#navbarDropdownMenu{ data: { toggle: 'dropdown' }, aria: { haspopup: true, expanded: false } }
              %i.fa.fa-user
              = current_user.username
            .dropdown-menu.dropdown-menu-right{ aria: { labelledby: 'navbarDropdownMenu' } }
              = link_to edit_user_registration_path, class: 'dropdown-item' do
                %i.fa.fa-edit
                = t '.edit_user_registration'
              .dropdown-divider
              = link_to destroy_user_session_path, class: 'dropdown-item', method: :delete do
                %i.fa.fa-power-off
                = t '.sign_out'
      - elsif controller.instance_of?(HomeController)
        %li.nav-item
          = link_to new_user_registration_path, class: 'btn btn-light', role: :button do
            %i.fa.fa-id-card.fa-fw
            = t '.sign_up'
        %li.nav-item.pl-2
          = link_to new_user_session_path, class: 'btn btn-primary', role: :button do
            %i.fa.fa-sign-in-alt
            = t '.sign_in'
      - else
        - unless controller.is_a?(Devise::SessionsController)
          %li.nav-item
            = link_to new_user_session_path, class: 'btn btn-outline-secondary', role: :button do
              %i.fa.fa-sign-in-alt
              = t '.sign_in'
        - unless controller.is_a?(Devise::RegistrationsController)
          %li.nav-item.pl-2
            = link_to new_user_registration_path, class: 'btn btn-outline-light', role: :button do
              %i.fa.fa-id-card.fa-fw
              = t '.sign_up'
CODE


### Build Grid-System layout with components

create_file 'app/views/layouts/grid_system.html.haml', <<CODE
- content_for :application_content do
  - unless defined?(header) && header == false
    %header#header
      = render partial: '/layouts/navbar'
  .container-fluid.h-100
    .row.h-100
      #side_menu_div.col-sm-3.bg-light
        - unless defined?(header) && header == false
          %div{ style: 'margin-bottom: 60px;' }
        #side_menu.pt-3
          = render partial: 'layouts/side_menu'
      #main_contents_div.col-sm-9
        #main_contents
          = content_for?(:content) ? yield(:content) : yield
        %footer#footer.mt-auto
          = render partial: 'layouts/footer'

= render template: 'layouts/application'
CODE

create_file 'app/javascript/src/grid_system_layout.css.scss', <<CODE
#header{
  z-index: 100;
}

#side_menu_div { 
  min-height: 100%;
}

#main_contents_div { 
  min-height: 100%;

  #main_contents{
    min-height: 100%;
    padding-top: 60px;
    margin-bottom: -20px;
    padding-bottom: 30px;
  }
}
CODE


create_file 'app/views/layouts/_side_menu.html.haml', <<EOS
%nav.nav.flex-column.nav-pills
  = link_to my_top_path, class: 'nav-link' do
    Top
EOS


## Add views

remove_file 'app/views/users/registrations/new.html.haml'
remove_file 'app/views/users/registrations/edit.html.haml'
remove_file 'app/views/users/passwords/new.html.haml'
remove_file 'app/views/users/passwords/edit.html.haml'
remove_file 'app/views/users/sessions/new.html.haml'


### Add views for Devise User's Registrations

create_file 'app/views/users/registrations/new.html.haml', <<'CODE'
%h2
  = t('devise.registrations.new.sign_up')

= render 'shared/alerts'

= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f|
  .form-inputs
    = f.input :username, autofocus: true
    = f.input :email
    = f.input :password, required: true
    = f.input :password_confirmation, required: true
  .form-actions
    = f.button :button, class: 'btn-primary btn-block btn-lg' do
      = t 'devise.registrations.new.sign_up'
CODE

create_file 'app/views/users/registrations/edit.html.haml', <<'CODE'
%h2
  = t('devise.registrations.edit.title', resource: resource.model_name.human)

= render 'shared/alerts'

= simple_form_for(resource, as: resource_name, url: registration_path(resource_name), html: { method: :put }) do |f|
  .form-inputs
    = f.input :username, autofocus: true
    = f.input :email
    - if devise_mapping.confirmable? && resource.pending_reconfirmation?
      %p
        = t('.currently_waiting_confirmation_for_email', email: resource.unconfirmed_email)
    = f.input :password, autocomplete: 'off', hint: t('devise.registrations.edit.leave_blank_if_you_don_t_want_to_change_it'), required: false
    = f.input :password_confirmation, required: false
    = f.input :current_password, hint: t('devise.registrations.edit.we_need_your_current_password_to_confirm_your_changes'), required: true
  .form-actions
    = f.button :button, class: 'btn-primary btn-block btn-lg' do
      = t 'devise.registrations.edit.update'

%hr

%h3
  = t('devise.registrations.edit.cancel_my_account')
%p
  = t('devise.registrations.edit.unhappy')
  = link_to(t('devise.registrations.edit.cancel_my_account'), registration_path(resource_name), data: { confirm: t('devise.registrations.edit.are_you_sure') }, method: :delete)
= link_to t('devise.shared.links.back'), :back
CODE


### Add view for Devise User's Passwords

create_file 'app/views/users/passwords/new.html.haml', <<'CODE'
%h2
  = t('devise.passwords.new.forgot_your_password')

= render 'shared/alerts'

= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :post }) do |f|
  .form-inputs
    = f.input :email, autofocus: true
  .form-actions
    = f.button :button, class: 'btn-primary btn-block' do
      = t 'devise.passwords.new.send_me_reset_password_instructions'
CODE

create_file 'app/views/users/passwords/edit.html.haml', <<'CODE'
%h2
  = t('devise.passwords.edit.change_your_password')

= render 'shared/alerts'

= simple_form_for(resource, as: resource_name, url: password_path(resource_name), html: { method: :put }) do |f|
  = f.input :reset_password_token, as: :hidden
  = f.full_error :reset_password_token
  .form-inputs
    = f.input :password, label: t('devise.passwords.edit.new_password'), required: true, autofocus: true
    = f.input :password_confirmation, label: t('devise.passwords.edit.confirm_new_password'), required: true
  .form-actions
    = f.button :button, class: 'btn-primary btn-block' do
      = t 'devise.passwords.edit.change_my_password'
CODE


### Add view for Devise User's Sessions

create_file 'app/views/users/sessions/new.html.haml', <<'CODE'
%h2
  = t('devise.sessions.new.sign_in')

= render 'shared/alerts'

= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f|
  .form-inputs
    = f.input :email, required: false, autofocus: true
    = f.input :password, required: false
    = f.input :remember_me, as: :boolean if devise_mapping.rememberable?
  .form-actions
    = f.button :button, class: 'btn-primary btn-block btn-lg' do
      = t 'devise.sessions.new.sign_in'

- if devise_mapping.recoverable?
  .text-right.mt-3
    = link_to new_password_path(resource_name), class:'text-muted' do
      = t 'devise.shared.links.forgot_your_password'
CODE

create_file 'app/views/layouts/_footer.html.haml', <<CODE
.version_no
  Ver.
  = #{app_name.camelize}::VERSION
%address.copylight
  = t 'copyright_html', year: Time.now.year
CODE


### Add layout for devise's views

create_file 'app/views/layouts/devise.html.haml', <<CODE
= render template: 'layouts/center_middle', locals:{ header: true }
CODE


### Add layout for my views

create_file 'app/views/layouts/my.html.haml', <<~EOS
= render template: 'layouts/grid_system'
EOS


### Add home views

create_file 'app/views/layouts/home.html.haml', <<~EOS
- content_for :application_content do
  - unless defined?(header) && header == false
    %header#header
      = render partial: '/layouts/navbar'
  .container-fluid.h-100
    .row.h-100
      #main_contents_div.col
        #main_contents
          = content_for?(:content) ? yield(:content) : yield
        %footer#footer.mt-auto
          = render partial: 'layouts/footer'

= render template: 'layouts/application'
EOS

remove_file 'app/views/home/index.html.haml'
create_file 'app/views/home/index.html.haml', <<'CODE'
= render 'shared/alerts'
CODE

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Style/FrozenStringLiteralComment"'


git add: %W[
	app/javascript/packs/application.js
	app/views/home/index.html.haml
	app/views/layouts/application.html.haml
	app/views/users/passwords/edit.html.haml
	app/views/users/passwords/new.html.haml
	app/views/users/registrations/edit.html.haml
	app/views/users/registrations/new.html.haml
	app/views/users/sessions/new.html.haml
	package.json
	yarn.lock
	app/javascript/src/application.scss
	app/javascript/src/base.css.scss
	app/javascript/src/center_middle_layout.css.scss
	app/javascript/src/grid_system_layout.css.scss
	app/views/layouts/_footer.html.haml
	app/views/layouts/_navbar.html.haml
	app/views/layouts/_side_menu.html.haml
	app/views/layouts/center_middle.html.haml
	app/views/layouts/devise.html.haml
	app/views/layouts/grid_system.html.haml
	app/views/layouts/home.html.haml
	app/views/layouts/my.html.haml
  app/views/shared/_alerts.html.haml
	config/initializers/#{app_name}.rb
	config/locales/#{app_name}.ja.yml
  lib/#{app_name}.rb
  lib/#{app_name}/version.rb
].join(' ')

git commit: "-m 'Apply bootstrap4 template by Kiribori.\n#{context}'"
