require 'yaml'

describe Broadcast::Share do

  context "when sharing something to Twitter" do

    let(:twitter_config) { YAML.load_file( File.expand_path('../config/twitter.yml', File.dirname(__FILE__)) )['twitter'] }
    let (:twitter_client) { Broadcast::Twitter.client }
    let (:previous_status_count) { twitter_client.user.tweets_count }
    let(:tweet) { twitter_client.user.status }

    let(:tumblr_config) { YAML.load_file( File.expand_path('../config/tumblr.yml', File.dirname(__FILE__)) )['tumblr'] }
    let(:tumblr_url) { tumblr_config["tumblr_url"] }
    let (:client) { Broadcast::Tumblr.client }
    let (:previous_post_count) { client.blog_info(tumblr_url)["blog"]["posts"] }
    let(:post) { client.posts(tumblr_url, limit: 1)["posts"].first }

    let(:message) { "just testing something #{Time.now}" }

    before do
      Broadcast::Twitter::configure twitter_config
      Broadcast::Tumblr::configure tumblr_config

      previous_status_count
      previous_post_count

      Broadcast::Share.to message, :twitter, :tumblr
    end

    after do
      twitter_client.destroy_status tweet
      client.delete tumblr_url, post["id"]
    end

    it "should be broadcasted" do

      expect(twitter_client.user.tweets_count).to eq (previous_status_count + 1)
      expect(tweet.text).to eq message

      expect(client.blog_info(tumblr_url)["blog"]["posts"]).to eq (previous_post_count + 1)
      expect(post["title"]).to eq message
    end

  end

end
