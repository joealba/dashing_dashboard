require 'yaml'
require 'jira'


jira_config = YAML.load_file File.join(File.expand_path(File.dirname(__FILE__)), '..', 'config', 'jira.yml')


SCHEDULER.every '15m', :first_in => 0 do
  options = {
    :username => jira_config[:username],
    :password => jira_config[:password],
    :context_path => '',
    :site     => jira_config[:host],
    :auth_type => :basic
  }
  client = JIRA::Client.new(options)
  # client = JIRA::Client.new({:consumer_key => CONSUMER_KEY, :consumer_secret => CONSUMER_SECRET})

  # projects = client.Project.all
  # issues = client.Issue.jql(jira_config[:jql], fields: %w(created description))
  issues = client.Issue.jql(jira_config[:jql])

  jira_issues = issues.map do |issue|
    {
      name: Time.parse(issue.created).strftime("%b %e, %Y %l:%M %p"),
      body: issue.summary
    }
  end

  send_event('jira_issues', comments: jira_issues, title: "Unresolved Jira issues")
end
