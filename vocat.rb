#!/usr/bin/env ruby
require "rubygems" # ruby1.9 doesn't "require" it though
require "thor"
require "aws-sdk"
require "socket"
require "yaml"
require "securerandom"

class Vocat < Thor

  desc "config", "Initial VOCAT installation task"
  def config

    say "I ask the questions. You answer the questions. Ready. Set. Go.", :red

    options = load_yaml
    scoped_options = options[environment]
    do_not_save = false
    scoped_options[:aws_enabled] = yes?("Do you want to enable S3 uploads and transcoding?", :yellow)
    if scoped_options[:aws_enabled] == true
      scoped_options[:aws] = {} if !scoped_options.has_key? :aws
      scoped_options[:aws][:key] = ask('Enter your AWS Key:', :yellow, default: scoped_options[:aws][:key])
      scoped_options[:aws][:secret] = ask('Enter your AWS Secret Key:', :yellow, default: scoped_options[:aws][:secret])
      scoped_options[:aws][:s3_bucket] = ask('Enter your S3 Bucket Name:', :yellow, default: scoped_options[:aws][:s3_bucket])
      scoped_options[:aws][:s3_region] = ask('Enter your region:', :yellow, limited_to: regions, default: scoped_options[:aws][:s3_region])
      scoped_options[:aws][:iam_et_role] = ask('Enter the IAM role name for the Elastic Transcoder to use:', :yellow, default: scoped_options[:aws][:iam_et_role])
      begin
        pipeline_id = execute_setup_aws(scoped_options[:aws])
        scoped_options[:aws][:et_pipeline] = pipeline_id
      rescue ConfigurationExecutionError
        do_not_save = true
      end
    else
      # Do nothing
    end

    options[environment] = scoped_options
    if do_not_save == true
      say "Unable to save your configuration due to error. Try again.", :red
    else
      say "Your configuration has been saved to config/environment.yml.", :yellow
      save_options_to_yaml(options)
    end
  end

  desc "setup_aws", "Perform AWS setup tasks"
  def setup_aws
    options = load_yaml
    scoped_options = options[environment]

    if scoped_options[:aws_enabled] == true
      execute_setup_aws(scoped_options[:aws])
    else
      say 'AWS is not currently enabled. Before running this command, either run vocat configure or update your config/environment.yml file to enable AWS support'
    end

  end


  private

    def environment
      environment = (ENV['RAILS_ENV'] || 'development').to_sym
    end

    def regions
      ['us-west-1', 'us-west-2', 'us-east-1', 'eu-west-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1']
    end

    def config_defaults
      {
        :aws_enabled => true,
        :aws => {
            :key => '',
            :secret => '',
            :s3_bucket => '',
            :s3_region => '',
            :et_pipeline => '',
            :iam_et_role => '',
            :et_preset => '1351620000001-100070'
        },
        :enable_ldap => true,
        :ldap => {
            :host => '',
            :base_dn => '',
            :bind_user => '',
            :bind_pw => ''
        }
      }
    end

    def load_yaml
      if File.exist?("#{File.dirname(__FILE__)}/config/environment.yml")
        results = YAML.load_file("#{File.dirname(__FILE__)}/config/environment.yml")
        results
      else
        {
          :development => config_defaults,
          :production => config_defaults,
          :testing => config_defaults
        }
      end
    end

    def execute_setup_aws(options)
      AWS.config(:access_key_id => options[:key], :secret_access_key => options[:secret])
      bucket = create_bucket(options[:s3_bucket], options[:s3_region])
      role = create_role(options[:iam_et_role])
      policy = create_role_policy(role)
      pipeline = create_pipeline(role, options[:s3_region], bucket, options[:et_pipeline])
      pipeline
    end

    def save_options_to_yaml(options)
      File.open("#{File.dirname(__FILE__)}/config/environment.yml", 'a+') do |f|
        f.truncate(0)
        f.write options.to_yaml
      end
    end


    def create_role_policy(role)
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
        response = iam.put_role_policy(role_name: role[:role_name], policy_name: policy_name, policy_document: policy_document)
        say "Successfully created or updated elastic transcoding policy.", :yellow
      rescue Exception => e
        say "Darn it, there was an exception while trying to create the IAM role policy: #{e}", :red
      end
    end

    def create_role(name)
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
        response = iam.get_role(:role_name => name)
        say "Found an existing role called #{name}. No need to create a new role.", :yellow
        role = response[:role]
      rescue AWS::IAM::Errors::NoSuchEntity
        say "Created a new role called #{name}.", :yellow
        response = iam.create_role({:role_name => name, :assume_role_policy_document => role_policy_document})
        role = response[:role]
      end
      role
    end

    def create_pipeline(role, region, bucket, pipeline_id = nil)
      pipeline_name = "vocat_#{bucket.name}"
      tc = AWS::ElasticTranscoder::Client.new({:region => region})
      begin
        response = tc.list_pipelines
        say "Looking for an existing pipeline with the id of #{pipeline_id}", :yellow
        pipeline = response.pipelines.first { |pipeline| pipeline[:id].eql?(pipeline_id) }
        if pipeline.nil?
          options = {
              name: pipeline_name,
              input_bucket: bucket.name,
              output_bucket: bucket.name,
              role: role[:arn],
              notifications: {
                  completed: '',
                  error: '',
                  warning: '',
                  progressing: ''
              }
          }
          response = tc.create_pipeline options
          pipeline = response[:pipeline]
          say "Successfully created transcoding pipeline.", :yellow
        else
          options = {
              id: pipeline[:id],
              name: pipeline_name,
              input_bucket: bucket.name,
              role: role[:arn],
          }
          response = tc.update_pipeline options
          pipeline = response[:pipeline]
          say "Successfully updated existing transcoding pipeline.", :yellow
        end
        return pipeline[:id]
      rescue Exception => e
        say "Ran into an exception trying to create the transcoding pipeline: #{e}" , :red
        raise ConfigurationExecutionError
      end
      return pipeline_id
    end

    def create_bucket(name, region)
      say "Attempting to create S3 bucket called #{name}", :yellow
      s3 = AWS::S3.new()
      s3.buckets.each do |bucket|
      end
      begin
        bucket = s3.buckets.create(name)
        say "Created a new bucket.", :yellow
      rescue AWS::S3::Errors::BucketAlreadyOwnedByYou
        say "This bucket has already been created and you own it. Woot.", :yellow
        bucket = s3.buckets[name]
      rescue Exception => e
       say e.to_s, :red
      end
      bucket
    end



end

class ConfigurationExecutionError < StandardError
end


Vocat.start