class AddAdditionalHstoresToRubric < ActiveRecord::Migration
  def up
    add_column :rubrics, :field_sorting, :hstore
    add_column :rubrics, :field_descriptions, :hstore
    add_column :rubrics, :range_lows, :hstore
    add_column :rubrics, :range_highs, :hstore
    add_column :rubrics, :range_descriptions, :hstore
    add_hstore_index :rubrics, :field_sorting
    add_hstore_index :rubrics, :field_descriptions
    add_hstore_index :rubrics, :range_lows
    add_hstore_index :rubrics, :range_highs
    add_hstore_index :rubrics, :range_descriptions
  end

  def down
    remove_column :rubrics, :field_sorting
    remove_column :rubrics, :field_descriptions
    remove_column :rubrics, :range_lows
    remove_column :rubrics, :range_highs
    remove_column :rubrics, :range_descriptions
  end
end
