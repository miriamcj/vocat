require 'spec_helper'

RSpec.describe "/manage/organizations/index.html.erb", type: :view do

  before(:each) do
    assign(:organizations, Kaminari.paginate_array([
        FactoryGirl.create(:organization),
        FactoryGirl.create(:organization)
      ]).page(1)
    )
    assign(:stats, Statistics::manage_org_stats)
  end

  it "renders a list of manage/organizations" do
    render
  end

end
