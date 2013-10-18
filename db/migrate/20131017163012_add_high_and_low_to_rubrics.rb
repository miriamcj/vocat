class AddHighAndLowToRubrics < ActiveRecord::Migration
  def change
    add_column :rubrics, :high, :integer
    add_column :rubrics, :low, :integer
  end
end
