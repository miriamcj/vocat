class AddCounterCacheToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :discussion_posts_count, :integer, :default => 0
    ids = Set.new
    DiscussionPost.all.each { |dp| ids << dp.submission_id }
    ids.each do |submission_id|
      Submission.reset_counters(submission_id, :discussion_posts)
    end
  end
end
