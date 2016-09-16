require 'rails_helper'

RSpec.describe "manage/organizations/edit.html.erb", type: :view do
  let(:valid_attributes) {
    org = FactoryGirl.build(:organization)
    org.attributes
  }
  before(:each) do
    assign(:organization, Organization.new(valid_attributes))
  end

  it "renders the edit organization form" do
    render
    # assert_select "form[action=?][method=?]", edit_organization_path(id: organization.id), "edit" do
    # end
  end
end
