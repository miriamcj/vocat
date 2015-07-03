namespace :attachments do

  desc "update_metadata"
  task :update_metadata => :environment do |task, args|

    Attachment.all.each do |attachment|
      attachment.variants.each do |variant|
        puts "Updating variant #{variant.id} file_size to #{variant.file_size}" if variant.update_content_length
        puts "Updating variant #{variant.id} with {duration: #{variant.duration}, width: #{variant.width}, height: #{variant.height}}" if variant.update_job_metadata
      end
    end
  end

  desc "clean"
  task :clean, [:confirm] => :environment do |task, args|

    if args.confirm == 'true'
      dry_run = false
      puts "THIS IS NOT A DRY RUN!!!!"
    else
      dry_run = true
      puts "THIS IS A DRY RUN."
    end

    orphans = Attachment.with_state(:uncommitted).where("video_id IS NULL AND created_at < :day", {:day => 1.day.ago})
    orphans.each do |attachment|
      puts "destroying orphan attachment: id ##{attachment.id} / state: #{attachment.state} / created: #{attachment.created_at}"
      if dry_run == false
        attachment.destroy
      end
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
      if dry_run == false
        bucket.objects[location].delete
      end
    end

  end

  desc "checkprocessing"
  task :checkprocessing => :environment do
    count = 0
    limit = 99999999

    processing = Attachment.with_state(:processing)
    processing.each do |attachment|
      # Instantiating is enough to check processing
      puts "Checking processing status for attachment: id ##{attachment.id} / state: #{attachment.state} / location: #{attachment.location}"
    end

    processed = Attachment.with_state(:processed)
    processed.each do |attachment|
      if !attachment.has_all_variants?
        break if count > limit
        count += 1
        puts "#{count}. reprocessing attachment: id ##{attachment.id} / state: #{attachment.state} / location: #{attachment.location}"
        attachment.undo_processing
        attachment.start_processing
      end
    end
  end

  desc "Truncate all tables and reseed"
  task :reseed => :environment do
    Rake::Task['db:truncate'].invoke
    Rake::Task['db:seed'].invoke
  end

end