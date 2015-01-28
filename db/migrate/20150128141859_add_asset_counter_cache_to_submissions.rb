class AddAssetCounterCacheToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :assets_count, :integer, :default => 0
    ids = Set.new
    Asset.all.each { |asset| ids << asset.submission_id }
    ids.each do |submission_id|
      Submission.reset_counters(submission_id, :assets)
    end
  end
end
