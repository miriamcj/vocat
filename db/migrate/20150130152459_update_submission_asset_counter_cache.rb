class UpdateSubmissionAssetCounterCache < ActiveRecord::Migration
  def up

    # Update asset counter caches on submissions
    ids = Set.new
    Asset.all.each { |asset| ids << asset.submission_id }
    ids.each do |submission_id|
      puts "updating counters for submission #{submission_id}"
      Submission.reset_counters(submission_id, :assets)
    end

  end

  def down
  end

end
