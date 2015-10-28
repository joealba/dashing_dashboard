require "sinatra/cyclist"
require 'dashing'

configure do
  set :auth_token, 'THISISMYAUTHTOKEN!THEREAREMANYLIKEITBUTTHISONEISMINE!'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

# set :routes_to_cycle_through, [:portal_view, :index, :index2]
set :routes_to_cycle_through, [:portal_view, :index]

run Sinatra::Application