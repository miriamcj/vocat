class AddIndexToEvaluations < ActiveRecord::Migration
  def change
    add_hstore_index :evaluations, :scores
  end
end
