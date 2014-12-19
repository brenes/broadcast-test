require 'yaml'

describe Broadcast::Twitter do

  context "when broadcasting something to Twitter" do

    let(:twitter_config) { YAML.load_file( File.expand_path('../config/twitter.yml', File.dirname(__FILE__)) )['twitter'] }
    let (:client) { Broadcast::Twitter.client }
    let (:previous_status_count) { client.user.tweets_count }
    let(:tweet) { client.user.status }
    let(:tweet_message) { "just testing something #{Time.now}" }

    before do
      Broadcast::Twitter::configure twitter_config

      previous_status_count
      Broadcast::Twitter.broadcast tweet_message
    end

    after do
      client.destroy_status tweet
    end

    it "should be broadcasted" do
      expect(client.user.tweets_count).to eq (previous_status_count + 1)
      expect(tweet.text).to eq tweet_message
    end

  end

end
