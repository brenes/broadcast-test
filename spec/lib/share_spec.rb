require 'yaml'

describe Broadcast::Share do

  context "when sharing something to Twitter" do

    let(:twitter_config) { YAML.load_file( File.expand_path('../config/twitter.yml', File.dirname(__FILE__)) )['twitter'] }
    let (:twitter_client) { Broadcast::Twitter.client }
    let (:previous_status_count) { twitter_client.user.tweets_count }
    let(:tweet) { twitter_client.user.status }
    let(:message) { "just testing something #{Time.now}" }

    before do
      Broadcast::Twitter::configure twitter_config

      previous_status_count
      Broadcast::Share.to message, :twitter
    end

    after do
      twitter_client.destroy_status tweet
    end

    it "should be broadcasted" do
      expect(twitter_client.user.tweets_count).to eq (previous_status_count + 1)
      expect(tweet.text).to eq message
    end

  end

end
