require 'yaml'

describe Broadcast::Tumblr do

  context "when broadcasting something to Tumblr" do

    let(:tumblr_config) { YAML.load_file( File.expand_path('../config/tumblr.yml', File.dirname(__FILE__)) )['tumblr'] }
    let(:tumblr_url) { tumblr_config["tumblr_url"] }
    let (:client) { Broadcast::Tumblr.client }
    let (:previous_post_count) { client.blog_info(tumblr_url)["blog"]["posts"] }

    let(:post) { client.posts(tumblr_url, limit: 1)["posts"].first }
    let(:message) { "just testing something #{Time.now.to_i}" }

    before do
      Broadcast::Tumblr::configure tumblr_config

      previous_post_count
      Broadcast::Tumblr.broadcast message
    end

    after do
      client.delete tumblr_url, post["id"]
    end

    it "should be broadcasted" do
      expect(client.blog_info(tumblr_url)["blog"]["posts"]).to eq (previous_post_count + 1)
      expect(post["title"]).to eq message
    end

  end

end
