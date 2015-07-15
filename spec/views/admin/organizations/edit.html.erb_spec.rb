require 'rails_helper'

RSpec.describe "admin/organizations/edit", type: :view do
  before(:each) do
    @admin_organization = assign(:admin_organization, Admin::Organization.create!())
  end

  it "renders the edit admin_organization form" do
    render

    assert_select "form[action=?][method=?]", admin_organization_path(@admin_organization), "post" do
    end
  end
end
