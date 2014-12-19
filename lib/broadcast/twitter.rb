require 'twitter'

module Broadcast
  class Twitter

    class << self
      attr_reader :client
    end

    def self.configure secrets
      @client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = secrets["consumer_key"]
        config.consumer_secret = secrets["consumer_secret"]
        config.access_token = secrets["access_token"]
        config.access_token_secret = secrets["access_token_secret"]
      end
    end

    def self.broadcast message
      @client.update message
    end

  end
end
