class AWSConfigurator

  ROLE_POLICY_DOCUMENT = {
      "Statement" => [
          {
              "Sid" => "",
              "Effect" => "Allow",
              "Principal" => {
                  "Service" => "elastictranscoder.amazonaws.com"
              },
              "Action" => "sts:AssumeRole"
          }
      ]
  }

  POLICY_DOCUMENT = {
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
  }

  def initialize
    @config = nil
    @global_config = nil
    @created_objects = {
        :bucket => nil,
        :pipeline => nil
    }
    load_yaml
  end

  def config
    @config
  end

  def configure(key, secret, region)
    configure_aws_credentials(key, secret)
    configure_create_aws_bucket
    configure_aws_region(region)
    configure_create_aws_role
    configure_create_aws_policy
    configure_create_aws_presets
    configure_create_aws_pipeline
    output_config
  end

  def configure_aws_credentials(key, secret)
    puts "  Setting credentials"
    @config[:aws][:key] = key
    @config[:aws][:secret] = secret
    AWS.config(:access_key_id => @config[:aws][:key], :secret_access_key => @config[:aws][:secret])
  end

  def configure_create_aws_bucket
    puts @config[:aws][:s3_bucket] ? "  Retrieving bucket" : "  Creating bucket"
    @created_objects[:bucket] = create_aws_bucket
    @config[:aws][:s3_bucket] = @created_objects[:bucket].name if @created_objects[:bucket].present?
  end

  def configure_aws_region(region)
    puts "  Setting region"
    @config[:aws][:s3_region] = region
  end

  def configure_create_aws_role
    puts @config[:aws][:iam_et_role] ? "  Retrieving role" : "  Creating role"
    @created_objects[:role] = create_aws_role
    @config[:aws][:iam_et_role] == @created_objects[:role][:name] if @created_objects[:role].present?
  end

  def configure_create_aws_policy
    puts "  Configuring policy"
    @created_objects[:policy] = create_aws_policy
  end

  def configure_create_aws_presets
    puts "  Configuring media presets"
    @created_objects[:mp4_preset] = create_aws_preset('mp4')
    @created_objects[:webm_preset] = create_aws_preset('webm')
    @config[:aws][:presets][:mp4] = @created_objects[:mp4_preset][:id] if @created_objects[:mp4_preset].present?
    @config[:aws][:presets][:webm] = @created_objects[:webm_preset][:id] if @created_objects[:webm_preset].present?
  end

  def configure_create_aws_pipeline
    puts "  Configuring pipeline"
    @created_objects[:pipeline] = create_aws_pipeline
    @config[:aws][:et_pipeline] = @created_objects[:pipeline][:id] if @created_objects[:pipeline].present?
  end

  protected

  def create_aws_bucket
    s3 = AWS::S3.new()
    exists = s3.buckets[@config[:aws][:s3_bucket]].exists?
    if exists == true
      bucket = s3.buckets[@config[:aws][:s3_bucket]]
      puts "    Found the existing bucket."
    else
      begin
        bucket = s3.buckets.create(@config[:aws][:s3_bucket])
        puts "    Created a new bucket."
      rescue AWS::S3::Errors::BucketAlreadyOwnedByYou
        puts "    This bucket has already been created and you own it."
        bucket = s3.buckets[@config[:aws][:s3_bucket]]
      rescue Exception => e
        warn e.to_s
      end
    end
    bucket
  end

  def create_aws_role
    # IAM Only allows resources to be created in us-east-1
    iam = AWS::IAM::Client.new({:region => 'us-east-1'})
    begin
      response = iam.get_role(:role_name => @config[:aws][:iam_et_role])
      puts "    Found an existing AWS role called #{@config[:aws][:iam_et_role]}."
      puts "    Assuming this role is setup correctly and am not altering it."
      role = response[:role]
    rescue AWS::IAM::Errors::NoSuchEntity
      response = iam.create_role({:role_name => @config[:aws][:iam_et_role], :assume_role_policy_document => ROLE_POLICY_DOCUMENT.to_json})
      warn "    Created a new AWS role called #{@config[:aws][:iam_et_role]}."
      role = response[:role]
    end
    role
  end

  def create_aws_policy
    # Roles are always created in this region, AFAIK.
    iam = AWS::IAM::Client.new({:region => 'us-east-1'})
    policy_name = "vocat_elastic_transcoder_policy"
    begin
      response = iam.put_role_policy(role_name: @created_objects[:role][:role_name], policy_name: policy_name, policy_document: POLICY_DOCUMENT.to_json)
      puts "    Created or updated the elastic transcoding policy."
    rescue Exception => e
      warn "    There was an exception while trying to create the IAM role policy: #{e}"
    end
    response
  end

  def create_aws_preset(type)
    preset_name = "VOCAT Preset - #{type}"
    et = AWS::ElasticTranscoder::Client.new({:region => @config[:aws][:s3_region]})
    presets = et.list_presets[:presets]
    existing_preset = presets.find { |preset| preset[:name] == preset_name }

    if !existing_preset
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
    else
      puts "    '#{preset_name}' already exists. If you would like VOCAT to recreate it, you must manually delete it."
      return existing_preset
    end
  end

  def create_aws_pipeline
    pipeline_name = "vocat_#{environment}_pipeline"
    tc = AWS::ElasticTranscoder::Client.new({:region => @config[:aws][:s3_region]})
    begin
      response = tc.list_pipelines
      existing_pipeline = response[:pipelines].find { |pipeline| pipeline[:id] == @config[:aws][:et_pipeline] }
      if existing_pipeline
        options = {
            id: @config[:aws][:et_pipeline],
            name: pipeline_name,
            input_bucket: @created_objects[:bucket].name,
            role: @created_objects[:role][:arn]
        }
        response = tc.update_pipeline options
        pipeline = response[:pipeline]
        puts "    Successfully updated existing transcoding pipeline."
      else
        options = {
            name: pipeline_name,
            input_bucket: @created_objects[:bucket].name,
            output_bucket: @created_objects[:bucket].name,
            role: @created_objects[:role][:arn],
            notifications: {
                completed: '',
                error: '',
                warning: '',
                progressing: ''
            }
        }
        response = tc.create_pipeline options
        pipeline = response[:pipeline]
        puts "    Successfully created transcoding pipeline."
      end
    rescue Exception => e
      warn "    Ran into an exception trying to create the transcoding pipeline: #{e}"
      raise ConfigurationExecutionError
    end
    return pipeline
  end

  def load_yaml
    if @global_config == nil
      if File.exist?("config/settings.yml.erb")
        settings = YAML.load_file("config/settings.yml.erb")
        secrets = YAML.load_file("config/secrets.yml")
        environments = settings.keys
        secrets.each do |key, value|
          symbol_key = key.to_sym
          if environments.include? symbol_key
            settings[symbol_key] = settings[symbol_key].deep_merge(value['vocat'])
          end
        end

        results = settings.deep_merge(secrets)
      else
        results = {
            :development => default_config,
            :production => default_config,
            :testing => default_config
        }
      end
      @global_config = results
      @config = default_config.deep_merge(results[environment])
    end
  end

  def output_config
    filename = ENV["VOCAT_AWS_CONFIG_FILE"]
    if filename.present?
      File.open(filename, "w+") do |f|
        generate_output(io: f)
      end
      puts "\e[33m\nAWS configuration written to #{filename}"
    else
      puts "\e[33m\nCopy the following to your '/etc/vocat/vocat.rb' file:\e[37m"
      generate_output(io: STDOUT)
    end
  end

  def generate_output(io: STDOUT)
    io.puts <<~EOF
      ################################################################################
      ## AWS S3 Configuration
      ################################################################################
    EOF

    @config[:aws].each do |k, v|
      if k == :presets
        v.each do |kk, vv|
          io.puts "vocat_rails['aws_preset_#{kk}']=#{vv.inspect}"
        end
      else
        io.puts "vocat_rails['aws_#{k}']=#{v.inspect}"
      end
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

  def environment
    (ENV['RAILS_ENV'] || 'development').to_sym
  end
end