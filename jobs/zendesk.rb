# require 'twitter'
require 'yaml'
require 'zendesk_api'

config_file = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'config', 'zendesk.yml')
if File.exists? config_file
  zendesk_config = YAML.load_file config_file

  client = ZendeskAPI::Client.new do |config|
    config.url = "https://#{zendesk_config[:domain]}.zendesk.com/api/v2"
    config.username = zendesk_config[:username]
    config.token = zendesk_config[:token]
    config.retry = true
  end


  SCHEDULER.every '10m', :first_in => 0 do |job|
    count = client.search(query: 'status:new').count
    send_event('zendesk_new_ticket_count', { title: "Zendesk: New ticket count", current: count, 'updated-at': Time.now.strftime("%A, %b %d") })
  end
end
