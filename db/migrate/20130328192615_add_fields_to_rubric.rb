class AddFieldsToRubric < ActiveRecord::Migration
  def up
    add_column :rubrics, :fields, :text
    add_column :rubrics, :ranges, :text
    add_column :rubrics, :owner_id, :integer
    add_column :rubrics, :description, :text
    add_column :rubrics, :organization_id, :integer
  end

  def down
    remove_column :rubrics, :fields, :text
    remove_column  :rubrics, :ranges, :text
    remove_column  :rubrics, :owner_id, :integer
    remove_column  :rubrics, :description, :text
    remove_column  :rubrics, :organization_id, :integer
  end

end
