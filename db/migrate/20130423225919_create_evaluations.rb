class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :submission_id
      t.integer :evaluator_id
      t.hstore :scores
      t.boolean :published
      t.integer :rubric_id

      t.timestamps
    end
  end
end
