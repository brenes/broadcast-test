require 'tumblr_client'

module Broadcast
  class Tumblr

    def self.configure secrets
      ::Tumblr.configure do |config|
        config.consumer_key = secrets["consumer_key"]
        config.consumer_secret = secrets["consumer_secret"]
        config.oauth_token = secrets["access_token"]
        config.oauth_token_secret = secrets["access_token_secret"]
      end
      @@tumblr_url = secrets["tumblr_url"]
    end

    def self.client
      ::Tumblr::Client.new
    end

    def self.broadcast message
      client.text @@tumblr_url, title: message, body: message
    end

  end
end
