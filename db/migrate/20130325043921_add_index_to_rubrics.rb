class AddIndexToRubrics < ActiveRecord::Migration
  def change
	  add_hstore_index :rubrics, :structure
  end
end
