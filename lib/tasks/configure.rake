# frozen_string_literal: true

YELLOW = "\e[33m"
CYAN = "\e[36m"
GREEN = "\e[32m"
WHITE = "\e[37m"
REGIONS = ['us-west-1', 'us-west-2', 'us-east-1', 'eu-west-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1'].freeze
cli = HighLine.new

namespace "config" do
  desc "Configure AWS for VOCAT"
  task aws: :environment do
    configurator = AWSConfigurator.new
    default_config = configurator.config[:aws]

    cli.say "#{YELLOW}\nWelcome to the VOCAT configuration tool. Today, we will be updating the #{CYAN}#{Rails.env}#{YELLOW} settings in your config/environment.yml file"

    cli.say "\nI need your AWS credentials to setup buckets, pipelines, and transcoding presets."
    aws_key = cli.ask("\n#{GREEN}What is your AWS Key? #{YELLOW}Press return to continue using:#{CYAN}") { |q| q.default = default_config[:key] }
    aws_secret = cli.ask("#{GREEN}What is your AWS Secret Key? #{YELLOW}Press return to continue using:#{CYAN}") { |q| q.default = default_config[:secret] }

    cli.say "#{YELLOW}To create the transcoding pipeline, I need to know what AWS region you plan on using."
    cli.say "\nAllowed regions: #{CYAN}#{REGIONS}"
    aws_region = cli.ask("#{GREEN}Enter your region: #{YELLOW}Press return to continue using:#{CYAN}") do |q|
      q.default = default_config[:s3_region]
      q.in = REGIONS
    end

    puts "\n#{WHITE}Configuring AWS..."
    configurator.configure(aws_key, aws_secret, aws_region)
  end
end