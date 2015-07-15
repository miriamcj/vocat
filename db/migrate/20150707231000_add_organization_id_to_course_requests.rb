class AddOrganizationIdToCourseRequests < ActiveRecord::Migration
  def change
    add_column :course_requests, :organization_id, :integer
  end
end
