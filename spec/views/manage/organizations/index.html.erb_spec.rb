require 'rails_helper'

RSpec.describe "manage/organizations/index.html.erb", type: :view do

  before(:each) do
    assign(:organizations, [
        FactoryGirl.build(:organization),
        FactoryGirl.build(:organization)
    ])
  end

  it "renders a list of manage/organizations" do
    render
  end
end
