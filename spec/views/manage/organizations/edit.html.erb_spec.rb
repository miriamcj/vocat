require 'spec_helper'

RSpec.describe "manage/organizations/edit.html.erb", type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
  end

  it "renders the edit organization form" do
    render

    # assert_select "form[action=?][method=?]", edit_organization_path(@organization), "post" do
    # end
  end
end
