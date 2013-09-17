class AddsTotalFieldsToEvaluations < ActiveRecord::Migration
  def up
    add_column :evaluations, :total_percentage, :decimal, :default => 0.0
    add_column :evaluations, :total_score, :decimal, :default => 0.0
  end

  def down
    remove_column :evaluations, :total_percentage
    remove_column :evaluations, :total_score
  end
end
