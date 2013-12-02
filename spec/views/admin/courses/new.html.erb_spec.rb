require 'spec_helper'

describe "admin/courses/new" do
  before(:each) do
    assign(:admin_course, stub_model(Admin::Course).as_new_record)
  end

  it "renders new admin_course form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", admin_courses_path, "post" do
    end
  end
end
