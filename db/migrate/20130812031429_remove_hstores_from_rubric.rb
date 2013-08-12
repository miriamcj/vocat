class RemoveHstoresFromRubric < ActiveRecord::Migration
  def up
	  remove_column :rubrics, :cells
	  remove_column :rubrics, :fields
	  remove_column :rubrics, :ranges
	  add_column :rubrics, :cells, :text
	  add_column :rubrics, :fields, :text
	  add_column :rubrics, :ranges, :text
  end

  def down
  end
end
