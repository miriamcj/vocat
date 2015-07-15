require 'rails_helper'

RSpec.describe "admin/organizations/new", type: :view do
  before(:each) do
    assign(:admin_organization, Admin::Organization.new())
  end

  it "renders new admin_organization form" do
    render

    assert_select "form[action=?][method=?]", admin_organizations_path, "post" do
    end
  end
end
