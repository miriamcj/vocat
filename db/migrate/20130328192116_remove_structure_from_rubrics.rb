class RemoveStructureFromRubrics < ActiveRecord::Migration
  def up
    remove_column :rubrics, :structure
  end

  def down
    add_column :rubrics, :structure, :hstore
  end
end
