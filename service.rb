require 'yaml'
require 'mongoid'
require './models/event'
require 'sinatra'

set :app_file, __FILE__
set :db_config_file, File.expand_path('config/mongoid.yml', settings.root)
set :db_config, YAML.load_file(settings.db_config_file)[settings.environment.to_s]
Mongoid.configure { |c| c.from_hash(settings.db_config) }

get '/api/v1/events/:id' do
  event = Event.find_by_id(params[:id].to_i)
  raise Sinatra::NotFound unless event
  event.to_json
end

get '/api/v1/tags/:tag/events' do
  events = Event.find(:tag => params[:tag])
  raise Sinatra::NotFound unless events
  events.to_json
end

post '/api/v1/events' do
  Event.create(JSON.parse(params[:event]))
end

get '/' do
  'Hello world!'
end
