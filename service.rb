require 'yaml'
require 'mongoid'
require './models/event'
require 'sinatra'
require 'sinatra/namespace'

set :app_file, __FILE__
set :db_config_file, File.expand_path('config/mongoid.yml', settings.root)
set :db_config, YAML.load_file(settings.db_config_file)[settings.environment.to_s]
Mongoid.configure { |c| c.from_hash(settings.db_config) }

helpers do
  def api_response(resource)
    pass unless resource
    resource.to_json
  end
end

namespace '/api/v1' do
  get('/events/:id') { api_response Event.find_by_id(params[:id].to_i) }
  get('/tags/:tag/events') { api_response Event.find(:tag => params[:tag]) }
  post('/events') { Event.create(JSON.parse(params[:event])) }
end

get('/') { 'Hello world!' }
