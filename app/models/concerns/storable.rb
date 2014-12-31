module Storable
  extend ActiveSupport::Concern

  def mime_type
    case extension
      when 'mp4'
        'video/mp4'
      when 'webm'
        'video/webm'
      when 'png'
        'image/png'
      when 'jpg'
        'image/jpg'
      when 'jpeg'
        'image/jpeg'
    end
  end

  def public_location
    s3 = get_s3_instance
    object = s3.buckets[bucket].objects[location]
    options = {}
    unless mime_type.blank?
      options[:response_content_type] = mime_type
    end
    object.url_for(:read, options).to_s
  end

  def bucket
    Rails.application.config.vocat.aws[:s3_bucket]
  end

  def destroy_file_object
    s3 = get_s3_instance
    unless location.blank?
      object = s3.buckets[bucket].objects[location]
      object.delete if object.exists?
    end
  end

  def get_s3_instance
    options = {
      :access_key_id => Rails.application.config.vocat.aws[:key],
      :secret_access_key => Rails.application.config.vocat.aws[:secret]
    }
    s3 = AWS::S3.new(options)
    s3
  end

  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document(key)
    ret = {
      "expiration" => 15.minutes.from_now.utc.xmlschema,
      "conditions" =>  [
        {"bucket" =>  Rails.application.config.vocat.aws[:s3_bucket]},
        ["starts-with", "$key", key],
        {"acl" => "private"},
        {"success_action_status" => "200"},
        ["content-length-range", 0, 5368709120]
      ]
    }
    Base64.encode64(ret.to_json).gsub(/\n/,'')
  end

  def s3_upload_signature(key, policy)
    secret = Rails.application.config.vocat.aws[:secret]
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, policy)).gsub("\n","")
  end

  def s3_upload_document
    policy = s3_upload_policy_document(location)
    {
      :policy => policy,
      :signature => s3_upload_signature(location, policy),
      :key => location
    }
  end

  def path_segment
    lower_thousand = (id/1000).floor * 1000
    upper_thousand = lower_thousand + 1000
    lower_hundred = (id/100).floor * 100
    upper_hundred = lower_hundred + 100
    "#{lower_thousand}_#{upper_thousand}/#{lower_hundred}_#{upper_hundred}"
  end



end
