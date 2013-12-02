require 'spec_helper'

describe "admin/courses/index" do
  before(:each) do
    assign(:admin_courses, [
      stub_model(Admin::Course),
      stub_model(Admin::Course)
    ])
  end

  it "renders a list of admin/courses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
