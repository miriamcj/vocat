require "thor"
require "rubygems" # ruby1.9 doesn't "require" it though
require "thor"
require "aws-sdk"
require "socket"
require "yaml"
require "securerandom"
require "active_support"

class Vocat < Thor

  package_name "Vocat"

  @@config = nil
  @@global_config = nil
  @@created_objects = {
      :bucket => nil,
      :pipeline => nil
  }

  YELLOW  = "\e[33m"
  CYAN    = "\e[36m"

  desc "configure", "Configure VOCAT"

  def configure
    say "\nWelcome to the VOCAT configuration tool. Today, we will be updating the #{CYAN}#{environment}#{YELLOW} settings in your config/environment.yml file\n", :yellow
    invoke "configure_aws"
    say "\n\n"
  end

  desc "configure_aws", "Configure AWS storage and transcoding"
  def configure_aws
    invoke "configure_create_aws_pipeline"
  end

  desc "configure_aws_credentials", "Configure AWS credentials"
  def configure_aws_credentials
    load_yaml
    say "\nI need your AWS credentials to setup buckets, pipelines, and transcoding presets.", :yellow
    @@config[:aws][:key] = ask("\nWhat is your AWS Key?#{CYAN}", :green, default: @@config[:aws][:key])
    @@config[:aws][:secret] = ask("What is your AWS Secret Key?#{CYAN}", :green, default: @@config[:aws][:secret])
    save_yaml
  end

  desc "configure_aws_region", "Configure AWS region to use"
  def configure_aws_region
    load_yaml
    say "\nTo create the transcoding pipeline, I need to know what AWS region you plan on using.", :yellow
    @@config[:aws][:s3_region] = ask("\nEnter your region:#{CYAN}", :green, limited_to: regions, default: @@config[:aws][:s3_region])
    save_yaml
  end

  desc "configure_create_aws_bucket", "Configure and create AWS bucket"
  def configure_create_aws_bucket
    invoke "configure_aws_credentials"
    say "\nI'm looking to see if you have already configured an AWS bucket.", :yellow
    if @@config[:aws][:s3_bucket]
      say "  Yep. Found it.", :yellow
      @@config[:aws][:s3_bucket] = ask("\nPress return to continue using this bucket, or enter a new bucket identifier.#{CYAN}", :green, default: @@config[:aws][:s3_bucket])
      verb = 'find'
    else
      say "  Nope. Looks like you haven't", :yellow
      @@config[:aws][:s3_bucket] = ask("\nWhat would you like to call the bucket that will store VOCAT's files?#{CYAN}", :green, default: @@config[:aws][:s3_bucket])
      verb = 'create'
    end
    say "\nI'm going to #{verb} the storage bucket now. This may take a few seconds.", :yellow
    @@created_objects[:bucket] = create_aws_bucket

    unless @@created_objects[:bucket].nil?
      say "  OK, I have the S3 bucket now", :yellow
      @@config[:aws][:s3_bucket] = @@created_objects[:bucket].name
    else
      say "  Hmm... I wasn't able to #{verb} the S3 bucket", :red
    end
    save_yaml
  end

  desc "configure_create_aws_role", "Configure and create the AWS role"
  def configure_create_aws_role
    say "\nBefore proceeding, I need to find or create the IAM Role that specifies what actions VOCAT can take on AWS.", :yellow
    @@config[:aws][:iam_et_role] = ask("\nPlease enter the name of the IAM role you want VOCAT to use.#{CYAN}", :green, default: @@config[:aws][:iam_et_role])
    say "\nI'm going to check for this role now and create it if it doesn't exist. Hang tight.", :yellow
    @@created_objects[:role] = create_aws_role
    unless @@created_objects[:role].nil?
      say "  OK, I have the IAM role now", :yellow
      @@config[:aws][:iam_et_role] == @@created_objects[:role][:name]
    else
      say "  Hmm... I wasn't able to create the IAM role", :red
    end
    save_yaml
  end

  desc "configure_create_aws_policy", "Configure and create Elastic Transcoder policy"
  def configure_create_aws_policy
    invoke "configure_aws_credentials"
    invoke "configure_aws_region"
    invoke "configure_create_aws_role"
    say "\nNow I need to create a policy for the VOCAT IAM role", :yellow
    @@created_objects[:policy] = create_aws_policy
    unless @@created_objects[:policy].nil?
      say "  OK, I have the policy now.", :yellow
    else
      say "  Hmm... I wasn't able to create or retrieve a policy for the IAM role", :red
    end
  end

  desc "configure_create_aws_presets", "Configure and create the Elastic Transcoder presets"
  def configure_create_aws_presets
    invoke "configure_aws_credentials"
    invoke "configure_aws_region"
    invoke "configure_create_aws_role"
    say "\nFine, I'm going to setup the transcoder presets for MP4 and Webm formats", :yellow
    @@created_objects[:mp4_preset] = create_aws_preset('mp4')
    @@created_objects[:webm_preset] = create_aws_preset('webm')
    unless @@created_objects[:mp4_preset].nil?
      say "  Huzzah. I have the mp4 preset.", :yellow
      @@config[:aws][:presets][:mp4] = @@created_objects[:mp4_preset][:id]
    else
      say "  What the heck! I couldn't create an MP4 preset.", :red
    end
    unless @@created_objects[:webm_preset].nil?
      say "  Well I'll be. I have the webm preset.", :yellow
      @@config[:aws][:presets][:webm] = @@created_objects[:webm_preset][:id]
    else
      say "  Are you kidding me? I couldn't create an Webm preset.", :red
    end
    save_yaml
  end

  desc "configure_create_aws_pipeline", "Configure and create the Elastic Transcoder pipeline"
  def configure_create_aws_pipeline
    invoke "configure_aws_credentials"
    invoke "configure_create_aws_bucket"
    invoke "configure_create_aws_policy"
    invoke "configure_create_aws_presets"
    @@config[:aws][:et_pipeline] = ask("\nEnter ET pipeline ID. If you leave it blank, I will attempt to create it for you. #{CYAN}", :green, default: @@config[:aws][:et_pipeline])
    @@created_objects[:pipeline] = create_aws_pipeline
    unless @@created_objects[:pipeline].nil?
      say "  Terrific, I now have the transcoding pipeline.", :yellow
      @@config[:aws][:et_pipeline] = @@created_objects[:pipeline][:id]
    else
      say "  Something went very wrong, and I don't have the transcoding pipeline.", :red
    end
    save_yaml
  end



  protected

  def create_aws_preset(type)
    preset_name = "VOCAT Preset - #{type}"
    AWS.config(:access_key_id => @@config[:aws][:key], :secret_access_key => @@config[:aws][:secret])
    et = AWS::ElasticTranscoder::Client.new({:region => @@config[:aws][:s3_region]})
    presets = et.list_presets[:presets]
    existing_preset = presets.find { |preset| preset[:name] == preset_name }
    if existing_preset
      say "  Deleting existing preset: '#{preset_name}'.", :yellow
      et.delete_preset({id: existing_preset[:id]})
    end

    say "  '#{preset_name}' doesn't exists. Hold on while I attempt to create it.", :yellow
    base_video_options = {
        :keyframes_max_dist => '90',
        :fixed_gop => 'false',
        :bit_rate => '2200',
        :frame_rate => '30',
        :max_width => '640',
        :max_height => '480',
        :sizing_policy => 'ShrinkToFit',
        :padding_policy => 'NoPad',
        :display_aspect_ratio => 'auto'
    }
    base_audio_options = {
        :sample_rate => '44100',
        :bit_rate => '160',
        :channels => '2'
    }
    if type == "mp4"
      video_options = base_video_options.clone
      video_options[:codec] = 'H.264'
      video_options[:codec_options] = {
          'Profile' => 'baseline',
          'MaxReferenceFrames' => '3',
          'Level' => '3.1'
      }
      audio_options = base_audio_options.clone
      audio_options[:codec] = 'AAC'
      audio_options[:codec_options] = {
          :profile => 'AAC-LC'
      }
    end
    if type == "webm"
      video_options = base_video_options.clone
      video_options[:codec] = 'vp8'
      video_options[:codec_options] = {
          'Profile' => '0'
      }
      audio_options = base_audio_options.clone
      audio_options[:codec] = 'vorbis'
    end

    preset_options = {
        :name => preset_name,
        :description => "The VOCAT #{type} transcoding preset. Generated automatically by VOCAT.",
        :container => type,
        :video => video_options,
        :audio => audio_options,
        :thumbnails => {
            :format => 'png',
            :interval => '99999',
            :max_width => '320',
            :max_height => '240',
            :sizing_policy => 'Fill',
            :padding_policy => 'Pad'
        }
    }
    preset = et.create_preset(preset_options)
    return preset[:preset]
  end

  def create_aws_bucket

    AWS.config(:access_key_id => @@config[:aws][:key], :secret_access_key => @@config[:aws][:secret])
    s3 = AWS::S3.new()

    exists = s3.buckets[@@config[:aws][:s3_bucket]].exists?
    if exists == true
      bucket = s3.buckets[@@config[:aws][:s3_bucket]]
      say "  Found the existing bucket.", :yellow
    else
      begin
        bucket = s3.buckets.create(@@config[:aws][:s3_bucket])
        say "  Created a new bucket.", :yellow
      rescue AWS::S3::Errors::BucketAlreadyOwnedByYou
        say "  This bucket has already been created and you own it.", :yellow
        bucket = s3.buckets[@@config[:aws][:s3_bucket]]
      rescue Exception => e
        say e.to_s, :red
      end
    end
    bucket
  end

  def create_aws_policy()

    # Roles are always created in this region, AFAIK.
    iam = AWS::IAM::Client.new({:region => 'us-east-1'})
    policy_name = "vocat_elastic_transcoder_policy"
    policy_document = '{
        "Statement": [
          {
            "Sid": "1",
            "Effect": "Allow",
            "Action": [
              "s3:ListBucket",
              "s3:Put*",
              "s3:Get*",
              "s3:*MultipartUpload*"
            ],
            "Resource": [
              "*"
            ]
          },
          {
            "Sid": "2",
            "Effect": "Allow",
            "Action": [
              "sns:Publish"
            ],
            "Resource": [
              "*"
            ]
          },
          {
            "Sid": "3",
            "Effect": "Deny",
            "Action": [
              "s3:*Policy*",
              "sns:*Permission*",
              "sns:*Delete*",
              "s3:*Delete*",
              "sns:*Remove*"
            ],
            "Resource": [
              "*"
            ]
          }
        ]
      }'
    begin
      response = iam.put_role_policy(role_name: @@created_objects[:role][:role_name], policy_name: policy_name, policy_document: policy_document)
      say "  I successfully created or updated the elastic transcoding policy.", :yellow
    rescue Exception => e
      say "  Darn it, there was an exception while trying to create the IAM role policy: #{e}", :red
    end
  end


  def create_aws_role()

    # IAM Only allows resources to be created in us-east-1
    iam = AWS::IAM::Client.new({:region => 'us-east-1'})
    role_policy_document = '{
        "Statement": [
          {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
              "Service": "elastictranscoder.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
          }
        ]
      }'
    begin
      response = iam.get_role(:role_name => @@config[:aws][:iam_et_role])
      say "  I found an existing AWS role called #{@@config[:aws][:iam_et_role]}.", :yellow
      say "  I am assuming this role is setup correctly and am not altering it.", :yellow
      role = response[:role]
    rescue AWS::IAM::Errors::NoSuchEntity
      response = iam.create_role({:role_name => name, :assume_role_policy_document => role_policy_document})
      role = response[:role]
      say "  I created a new AWS role called #{@@config[:aws][:iam_et_role]}.", :yellow
    end
    role
  end


  def create_aws_pipeline()
    pipeline_name = "vocat_#{environment}_pipeline"
    tc = AWS::ElasticTranscoder::Client.new({:region => @@config[:aws][:s3_region]})
    begin
      response = tc.list_pipelines
      existing_pipeline = response[:pipelines].find { |pipeline| pipeline[:id] == @@config[:aws][:et_pipeline] }
      unless existing_pipeline
        options = {
            name: pipeline_name,
            input_bucket: @@created_objects[:bucket].name,
            output_bucket: @@created_objects[:bucket].name,
            role: @@created_objects[:role][:arn],
            notifications: {
                completed: '',
                error: '',
                warning: '',
                progressing: ''
            }
        }
        response = tc.create_pipeline options
        pipeline = response[:pipeline]
        say "  Successfully created transcoding pipeline.", :yellow
      else
        options = {
            id: @@config[:aws][:et_pipeline],
            name: pipeline_name,
            input_bucket: @@created_objects[:bucket].name,
            role: @@created_objects[:role][:arn],
        }
        response = tc.update_pipeline options
        pipeline = response[:pipeline]
        say "  Successfully updated existing transcoding pipeline.", :yellow
      end
    rescue Exception => e
      say "  Ran into an exception trying to create the transcoding pipeline: #{e}" , :red
      raise ConfigurationExecutionError
    end
    return pipeline
  end

  def regions
    ['us-west-1', 'us-west-2', 'us-east-1', 'eu-west-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1']
  end

  def environment
    (ENV['RAILS_ENV'] || 'development').to_sym
  end

  def save_yaml
    path = "#{File.dirname(__FILE__)}/config/environment.yml"
    say "  Updating yaml at #{path}", :yellow
    File.open(path, 'a+') do |f|
      f.truncate(0)
      @@global_config[environment] = @@config
      f.write @@global_config.to_yaml
    end
  end

  def load_yaml
    if @@global_config == nil



      if File.exist?("#{File.dirname(__FILE__)}/config/environment.yml")
        results = YAML.load_file("#{File.dirname(__FILE__)}/config/environment.yml")
      else
        results = {
            :development => config_defaults,
            :production => config_defaults,
            :testing => config_defaults
        }
      end
      @@global_config = results


      @@config = default_config.deep_merge(results[environment])
    end
  end

  def default_config
    {
        aws: {
            enabled: nil,
            key: nil,
            secret: nil,
            s3_bucket: nil,
            s3_region: nil,
            et_pipeline: nil,
            iam_et_role: nil,
            presets: {
                webm: nil,
                mp4: nil
            }
        }
    }

  end


end