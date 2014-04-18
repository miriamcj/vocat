FactoryGirl.define do
  factory :attachment do
    media_file_name 'group1.mov'
    media_content_type 'video/quicktime'
    media_file_size 1269389
    media_updated_at Date.today
    state 'uncommitted'
    processor_error nil
    processed_key nil
    processor_job_id nil
    processor_class nil
    processed_thumb_key nil
    association :video, factory: :video
    association :user, factory: :user
  end
end
