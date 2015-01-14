class AddDefaultToEvaluationsPublished < ActiveRecord::Migration
  def up
    Evaluation.where({:published => false}).update_all({:published => nil})
    change_column :evaluations, :published, :boolean, :default => false
  end

  def down
    change_column :evaluations, :published, :boolean, :default => nil
  end

end
