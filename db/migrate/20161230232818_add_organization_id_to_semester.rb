class AddOrganizationIdToSemester < ActiveRecord::Migration[5.0]
  def change
    add_column :semesters, :organization_id, :integer
    add_index "semesters", ["organization_id"], :name => "index_semesters_on_organization_id"
  end
end
