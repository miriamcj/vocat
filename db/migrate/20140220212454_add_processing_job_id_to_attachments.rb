class AddProcessingJobIdToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :processor_job_id, :string
  end
end
