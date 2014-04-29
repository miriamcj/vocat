namespace :attachments do

  desc "clean"
  task :clean => :environment do
    orphans = Attachment.with_state(:uncommitted).where("video_id IS NULL AND created_at < :day", {:day => 1.day.ago})
    orphans.each do |attachment|
      puts "destroying orphan attachment: id ##{attachment.id} / state: #{attachment.state} / created: #{attachment.created_at}"
      attachment.destroy
    end

    options = {
        :access_key_id => Rails.application.config.vocat.aws[:key],
        :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }

    valid_locations = []
    Attachment.all.each do |attachment|
      valid_locations.push attachment.location
    end
    valid_locations += Attachment::Variant.pluck(:location)
    valid_locations.uniq

    existing_locations = []
    s3 = AWS::S3.new(options)
    bucket = s3.buckets[Rails.application.config.vocat.aws[:s3_bucket]]
    bucket.objects.each do |object|
      existing_locations.push object.key
    end

    delete_locations = existing_locations - valid_locations
    delete_locations = delete_locations.reject { |location| location[-1,1] == '/' }

    delete_locations.each do |location|
      puts "deleting S3 object: #{location}"
      bucket.objects[location].delete
    end

  end

  desc "checkprocessing"
  task :checkprocessing => :environment do

    count = 0
    limit = 1

    processed = Attachment.with_state(:processed)

    processed.each do |attachment|
      if !attachment.has_all_variants?
        puts "reprocessing attachment: id ##{attachment.id} / state: #{attachment.state} / location: #{attachment.location}"
        count += 1
        attachment.undo_processing
        attachment.start_processing
        break if count >= limit
      end
    end
  end

  desc "Truncate all tables and reseed"
  task :reseed => :environment do
    Rake::Task['db:truncate'].invoke
    Rake::Task['db:seed'].invoke
  end

end