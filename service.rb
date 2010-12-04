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
  get('/events/:id') { api_response Event.find(params[:id]) }
  get('/tags/:tag/events') { api_response Event.find(:tag => params[:tag]) }
  post('/events') { Event.create(JSON.parse(params[:event])) }
  get('/events') {
    if params[:bbox]
      api_response Event.where(:location.within => {"$box" => JSON.parse(params[:bbox]) } ).find()
    else
      api_response Event.find()
    end
  }
end

get('/') { 'Hello world!' }
