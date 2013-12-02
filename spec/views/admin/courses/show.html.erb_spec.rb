require 'spec_helper'

describe "admin/courses/show" do
  before(:each) do
    @admin_course = assign(:admin_course, stub_model(Admin::Course))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
