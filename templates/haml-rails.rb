# frozen_string_literal: true

gem 'haml-rails'
append_to_file '.env', 'HAML_RAILS_DELETE_ERB=true'
run 'bundle install'
rails_command 'haml:erb2haml'
