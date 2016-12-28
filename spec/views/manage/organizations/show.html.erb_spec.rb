require 'spec_helper'

RSpec.describe "manage/organizations/show.html.erb", type: :view do
  before(:each) do
    @organization = FactoryGirl.create(:organization)
    assign(:stats, Statistics::single_organization_stats(@organization))
  end

  it "renders attributes in <p>" do
    render
  end
end
