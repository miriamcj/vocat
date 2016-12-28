require 'spec_helper'

RSpec.describe "manage/organizations/new.html.erb", type: :view do
  before(:each) do
    assign(:organization, FactoryGirl.create(:organization))
  end

  it "renders new organization form" do
    render

    # assert_select "form[action=?][method=?]", organizations_path, "post" do
    # end
  end
end
