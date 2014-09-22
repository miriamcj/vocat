class AddDefaultToEvaluationsPublished < ActiveRecord::Migration
  def up
    Evaluation.update_all({:published => false}, {:published => nil})
    change_column :evaluations, :published, :boolean, :default => false
  end

  def down
    change_column :evaluations, :published, :boolean, :default => nil
  end

end
