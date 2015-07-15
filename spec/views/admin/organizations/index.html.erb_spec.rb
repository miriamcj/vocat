require 'rails_helper'

RSpec.describe "admin/organizations/index", type: :view do
  before(:each) do
    assign(:admin_organizations, [
      Admin::Organization.create!(),
      Admin::Organization.create!()
    ])
  end

  it "renders a list of admin/organizations" do
    render
  end
end
