class AddEvaluationTypeToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :evaluation_type, :integer
  end
end
