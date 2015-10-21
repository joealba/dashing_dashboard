require 'twitter'
require 'yaml'

twitter_config = YAML.load_file File.join(File.expand_path(File.dirname(__FILE__)), '..', 'config', 'twitter.yml')

#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = twitter_config['consumer_key']
  config.consumer_secret = twitter_config['consumer_secret']
  config.access_token = twitter_config['access_token']
  config.access_token_secret = twitter_config['access_token_secret']
end


SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    # search_term = URI::encode('#todayilearned')
    # tweets = twitter.search("#{search_term}")

    tweets = twitter.home_timeline

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end