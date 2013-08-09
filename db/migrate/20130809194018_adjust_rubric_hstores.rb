class AdjustRubricHstores < ActiveRecord::Migration
  def up
    add_column :rubrics, :cells, :hstore
    add_hstore_index :rubrics, :cells
    remove_column :rubrics, :field_sorting
    remove_column :rubrics, :field_descriptions
    remove_column :rubrics, :range_lows
    remove_column :rubrics, :range_highs
    remove_column :rubrics, :range_descriptions
  end

end
