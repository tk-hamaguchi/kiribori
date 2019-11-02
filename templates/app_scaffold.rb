# Kiribori Template for app_scaffold


## Add Group model

generate :model, 'Group', 'name:string', 'lock_version:integer', 'deleted_at:timestamp'
prepend_to_file 'app/models/group.rb', "# Group\n#\n"

inject_into_class 'app/models/group.rb', 'Group', <<CODE

  ### associations

  has_many :users, dependent: :destroy

  ### callbacks

  ### validations

  validates :name,
            presence: true,
            length: { in: 2..40 }

  ### mix-in

  acts_as_paranoid

  ### methods

CODE

gsub_file 'spec/models/group_spec.rb', /^.*pending.*$/, <<CODE
  subject(:described_instance) { FactoryBot.build :group }

  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(40) }
  end

  describe 'mix-in' do
    describe 'acts_as_paranoid' do
      describe 'class' do
        subject { described_class }

        it { is_expected.to respond_to :with_deleted }
        it { is_expected.to respond_to :only_deleted }
      end

      describe 'instance' do
        subject { described_instance }

        it { is_expected.to respond_to :deleted? }
        it { is_expected.to respond_to :recover }
      end
    end
  end
CODE

insert_into_file 'spec/factories/faker.rb', "  sequence(:group_name) { Faker::Games::Pokemon.location }\n", before: /^end$/
gsub_file 'spec/factories/groups.rb', /(\n  factory :group do\n).+(\n  end)/m, '\1name { generate :group_name }\2'


## Add logic to User model

generate :migration, 'AddGroupRefToUsers group:references'

insert_into_file 'app/models/user.rb', "\n\n  belongs_to :group", after: /^  ### associations$/
insert_into_file 'app/models/user.rb', "\n\n  before_validation :create_group, on: :create", after: /^  ### callbacks$/

insert_into_file 'app/models/user.rb', <<CODE, after: /^  ### methods$/

  private

  def create_group
    self.group = Group.create(name: username)
  end
CODE

insert_into_file 'spec/models/user_spec.rb', <<CODE, after: /^RSpec.describe User, type: :model do$/
  subject(:described_instance) { FactoryBot.build :user }

CODE

## Apply to DB

rails_command 'db:migrate'


## Recreate my/top page

remove_file 'app/views/my/top.html.haml'
create_file 'app/views/my/top.html.haml', "= render 'shared/alerts'\n"


## Generate my/users resources

generate :controller, 'my/users', 'index', 'show', 'new', 'create', 'edit', 'update', 'destroy', '--skip-routes', '--no-helper', '--no-assets'
insert_into_file 'config/routes.rb', "    resources :users\n", after: "namespace :my do\n"
gsub_file 'app/controllers/my/users_controller.rb', 'ApplicationController',  'MyController'
prepend_to_file 'app/controllers/my/users_controller.rb', "# My::UsersController\n"
insert_into_file 'app/controllers/my/users_controller.rb', "\n  # GET /my/users\n", before: /^  def index$/

insert_into_file 'app/controllers/my/users_controller.rb', <<CODE.rstrip, after: /^  def index$/

    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(params, current_user: current_user) }
    end
CODE

insert_into_file 'app/controllers/my/users_controller.rb', "  # GET /my/users/:id\n", before: /^  def show$/
inject_into_class 'app/controllers/my/users_controller.rb', 'My::UsersController', "  before_action :set_user, only: %i[show update destroy]\n"
insert_into_file 'app/controllers/my/users_controller.rb', <<CODE, before: /^end$/

  private

  def set_user
    @user = policy_scope(User).find(params[:id])
  end

  def users_params
    params.require(:users).permit(:email, :username, :group_id, :password, :password_confirmation)
  end

CODE

prepend_to_file 'app/decorators/my/user_decorator.rb', "# My::UserDecorator\n"
insert_into_file 'spec/decorators/my/user_decorator_spec.rb', "  pending\n", before: /^end$/

gsub_file 'spec/controllers/my/users_controller_spec.rb', /(\nRSpec.describe My::UsersController, type: :controller do\n).+(\nend)/m, '\1\2'


## Add authenticate for User

generate 'pundit:policy', 'User'


## Add logic to User's datatable

generate 'datatable', 'User'
gsub_file 'app/datatables/user_datatable.rb', /^\s*#[^\n]*\n/, ''
prepend_to_file 'app/datatables/user_datatable.rb', "# UserDatatable\n"
insert_into_file 'app/datatables/user_datatable.rb', "\n    Pundit.policy_scope(current_user, User)", after: /^  def get_raw_records$/

inject_into_class 'app/datatables/user_datatable.rb', 'UserDatatable', <<CODE

  def current_user
    @current_user ||= options[:current_user]
  end
CODE

insert_into_file 'app/datatables/user_datatable.rb', <<CODE, after: "    @view_columns ||= {\n"
      username: { source: "User.username" },
      email:    { source: "User.email" }
CODE

insert_into_file 'app/datatables/user_datatable.rb', <<CODE, after: "  def data\n    records.map do |record|\n      {\n"
        DT_RowId: record.id,
        username: record.username,
        email:    record.email
CODE

create_file 'app/javascript/src/datatable.css.scss', "@import '~datatables.net-bs4/css/dataTables.bootstrap4';\n"

create_file 'app/javascript/packs/my_user_table_vue.js', <<CODE
import Vue from 'vue'
//import Vue from 'vue/dist/vue.esm'
import App from '../my_user_table.vue'
import 'bootstrap'
import '../src/datatable.css.scss'

require( 'datatables.net-bs4' )();

import TurbolinksAdapter from 'vue-turbolinks';
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  var element = document.getElementById("my_user_table")
  if (element != null) { (new Vue(App)).$mount(element) }
})
CODE


create_file 'app/javascript/my_user_table.vue', <<'CODE'
<template>
  <div id="app">
    <div class="table-responsive">
      <table id="users-datatable" data-source="/my/users.json" class="table table-bordered dataTable">
        <thead>
          <tr>
          <th>User Name</th>
          <th>Email</th>
          </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
export default {
  mounted: function() {
    jQuery('#users-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "columnDefs": [
        { "width": "1.5em", "orderable": false, "targets": 0 },
        { "width": "8.5em", "orderable": false, "targets": -1 }
      ],
      "ajax": { "url": "/my/users.json" },
      "language": { "url": "//cdn.datatables.net/plug-ins/1.10.19/i18n/Japanese.json" },
      "drawCallback": function( settings ) {
        $('#users-datatable a[data-toggle="tooltip"]').tooltip()
        jQuery('#users-datatable a[data-toggle="modal"]').click(function(e) {
          e.preventDefault();
          var url = jQuery(this).attr('href');
          if (url.indexOf('#') == 0) {
            jQuery(url).modal('open');
          } else {
            jQuery.get(url, function(data) {
              jQuery('<div class="modal" tabindex="-1" role="dialog">  <div class="modal-dialog" role="document">    <div class="modal-content">      <div class="modal-header">        <h5 class="modal-title">Modal title</h5>        <button type="button" class="close" data-dismiss="modal" aria-label="Close">          <span aria-hidden="true">&times;</span>        </button>      </div>      <div class="modal-body">        <p>Modal body text goes here.</p>      </div>      <div class="modal-footer">        <button type="button" class="btn btn-primary">Save changes</button>        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>      </div>    </div>  </div></div>').modal();
        //    }).success(function() {
        //      jQuery('input:text:visible:first').focus();
            });
          }
        });
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "username"},
        {"data": "email"}
      ],
      "order": [[ 1, "asc" ]]
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
    });

  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
CODE


remove_file 'app/views/my/users/index.html.haml'
create_file 'app/views/my/users/index.html.haml', <<'CODE'
.card.shadow.mb-4
  .card-body
    %my_user_table#my_user_table

- content_for :javascript_links do
  = javascript_pack_tag 'my_user_table_vue', 'data-turbolinks-track': 'reload', 'data-turbolinks-suppress-warning': 'false'
CODE


bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Layout/TrailingBlankLines,Style/FrozenStringLiteralComment,Layout/EmptyLines,Style/StringLiterals"'
