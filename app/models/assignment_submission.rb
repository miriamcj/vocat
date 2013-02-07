class AssignmentSubmission < ActiveRecord::Base
  attr_accessible :description, :name, :media
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/aws.yml",
                    :path => ":year/:month/:day/:hash.:extension",
                    :hash_secret => "+hequ!ckbr0wnf@Xjump5o^3rThe1azyd0g"

  Paperclip.interpolates(:year)  {|a, style| (a.instance.created_at && a.instance.created_at.year)  || Time.new.year }
  Paperclip.interpolates(:month) {|a, style| (a.instance.created_at && a.instance.created_at.month) || Time.new.month }
  Paperclip.interpolates(:day)   {|a, style| (a.instance.created_at && a.instance.created_at.day)   || Time.new.day }

  validates :media, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :media

  def transcode_media
    return if media_content_type == "video/mp4"

    # Create the ElasticTranscoder object
    options = media.s3_credentials
    mp4Options = options[:transcoding]["mp4"]
    et = AWS::ElasticTranscoder.new(options)

    inputKey = media.interpolator.interpolate media.options[:path], media, :original
    base = File.dirname(inputKey)+"/"+File.basename(inputKey, ".*")
    outputKey = base+".mp4"
    thumbPattern = base+"_thumb{count}"

    # Queue the job
    result = et.client.create_job(
        :pipeline_id => mp4Options['pipeline'],
        :input => {
            :key => inputKey,
            :frame_rate => 'auto',
            :resolution => 'auto',
            :aspect_ratio => 'auto',
            :interlaced => 'auto',
            :container => 'auto'
        },
        :output => {
            :key => outputKey,
            :thumbnail_pattern => thumbPattern,
            :rotate => '0',
            :preset_id => mp4Options['preset']
        })
  end
end
