require 'yaml'
require 'mongoid'

file_name = File.join(File.dirname(__FILE__), "config", "mongoid.yml")
@settings = YAML.load_file(file_name)
env = ENV['RACK_ENV'] || 'development'

Mongoid.configure do |config|
  config.from_hash(@settings[env])
end

require './models/event'
require 'sinatra'

get '/api/v1/events/:id' do
  Event.find_by_id(params[:id].to_i).to_json
end

post '/api/v1/events/' do
  debugger
  Event.create(JSON.parse(params))
end