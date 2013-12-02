require 'spec_helper'

describe "admin/courses/edit" do
  before(:each) do
    @admin_course = assign(:admin_course, stub_model(Admin::Course))
  end

  it "renders the edit admin_course form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_course_path(@admin_course), "post" do
    end
  end
end
