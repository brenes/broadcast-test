require 'twitter'
require 'yaml'

module Broadcast
    class Twitter

    def self.client
      @@client ||= ::Twitter::REST::Client.new do |config|
        yml_config = YAML.load_file( File.expand_path('../../config/twitter.yml', File.dirname(__FILE__)) )['twitter']
        config.consumer_key = yml_config["consumer_key"]
        config.consumer_secret = yml_config["consumer_secret"]
        config.access_token = yml_config["access_token"]
        config.access_token_secret = yml_config["access_token_secret"]
      end
      @@client
    end

    def self.broadcast message
      @@client.update message
    end

  end
end
