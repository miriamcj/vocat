class MigrateVideosToAssets < ActiveRecord::Migration

  def up
    create_table :assets do |t|
      t.string :type
      t.string :name
      t.integer :author_id
      t.integer :submission_id
      t.integer :listing_order
      t.string :external_location
      t.string :external_source
      t.timestamps
    end

    add_column :attachments, :asset_id, :integer
    add_column :projects, :allowed_attachment_families, :text, array: true, default: []
    add_column :annotations, :asset_id, :integer
    add_column :annotations, :canvas, :text
    add_column :submissions, :assets_count, :integer, :default => 0

    sql = 'SELECT * FROM videos where source = \'youtube\''
    results = ActiveRecord::Base.connection.execute(sql)
    results.ntuples.times do |i|
      video = results[i]
      asset = Asset::Youtube.create({
                                :name => video["name"],
                                :author_id => nil,
                                :submission_id => video["submission_id"],
                                :created_at => video["created_at"],
                                :updated_at => video["update_at"],
                                :external_location => video["source_id"],
                                :external_source => 'youtube'
                            })
      puts "migrating YOUTUBE video #{video['id']} to asset #{asset.id}"

      update_sql = "UPDATE annotations SET asset_id = #{asset.id} WHERE video_id = #{video['id']}"
      ActiveRecord::Base.connection.execute(update_sql)
      puts "migrating ANNOTATIONS for video #{video['id']} TO asset #{asset.id}"

    end

    sql = 'SELECT * FROM videos where source = \'vimeo\''
    results = ActiveRecord::Base.connection.execute(sql)
    results.ntuples.times do |i|
      video = results[i]
      asset = Asset::Vimeo.create({
                                :name => video["name"],
                                :author_id => nil,
                                :submission_id => video["submission_id"],
                                :created_at => video["created_at"],
                                :updated_at => video["update_at"],
                                :external_location => video["source_id"],
                                :external_source => 'vimeo'
                            })
      puts "migrating VIMEO video #{video['id']} to asset #{asset.id}"

      update_sql = "UPDATE annotations SET asset_id = #{asset.id} WHERE video_id = #{video['id']}"
      ActiveRecord::Base.connection.execute(update_sql)
      puts "migrating ANNOTATIONS for video #{video['id']} TO asset #{asset.id}"

    end

    sql = 'SELECT * FROM videos where source = \'attachment\''
    results = ActiveRecord::Base.connection.execute(sql)
    results.ntuples.times do |i|
      video = results[i]
      asset = Asset::Video.create({
                              :name => video["name"],
                              :author_id => nil,
                              :submission_id => video["submission_id"],
                              :created_at => video["created_at"],
                              :updated_at => video["update_at"],
                              :external_location => video["source_id"],
                              :external_source => 'vimeo'
                          })
      asset.attachment = Attachment.where({video_id: video["id"]}).first
      asset.save
      puts "migrating ATTACHMENT video #{video['id']} to asset #{asset.id}"

      update_sql = "UPDATE annotations SET asset_id = #{asset.id} WHERE video_id = #{video['id']}"
      ActiveRecord::Base.connection.execute(update_sql)
      puts "migrating ANNOTATIONS for video #{video['id']} TO asset #{asset.id}"

    end

    rename_column :annotations, :video_id, :video_id_to_delete
    rename_column :attachments, :video_id, :video_id_to_delete
    rename_table :videos, :videos_to_delete


    # # Update asset counter caches on submissions
    # ids = Set.new
    # Asset.all.each { |asset| ids << asset.submission_id }
    # ids.each do |submission_id|
    #   puts "updating counters for submission #{submission_id}"
    #   Submission.reset_counters(submission_id, :assets)
    # end


  end


  def down
    drop_table :assets
    remove_column :attachments, :asset_id, :integer
    remove_column :projects, :allowed_attachment_families, :text, array: true, default: []
    remove_column :annotations, :asset_id, :integer
    remove_column :annotations, :canvas, :text
    remove_column :submissions, :assets_count, :integer, :default => 0
    rename_table :videos_to_delete, :videos
    rename_column :annotations, :video_id_to_delete, :video_id
    rename_column :attachments, :video_id_to_delete, :video_id
  end


end
