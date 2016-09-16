require 'rails_helper'

RSpec.describe "manage/organizations/new", type: :view do
  before(:each) do
    assign(:organization, FactoryGirl.create(:organization))
  end

  it "renders new organization form" do
    render
    assert_select "form[action=?][method=?]", new_organization_path, "get" do
    end
  end
end
