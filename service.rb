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
  def api_response_for(model, resource)
    pass unless resource
    { model => resource }.to_json
  end
  def api_response_for_multiple(model, resources)
    pass if resources.empty?
    { model => resources }.to_json
  end
end

#BSON::InvalidObjectId

namespace '/api/v1' do
  namespace '/events' do
  
    # return list of events
    get do
      criteria = Event.find(:all)
      if params[:bbox]
        criteria = criteria.where(:location.within => {"$box" => JSON.parse(params[:bbox])})
      end
      if params[:within_radius]
        criteria = criteria.where(:location.within => {"$center" => JSON.parse(params[:within_radius])})
      end
      if params[:tag]
        criteria = criteria.where(:tags => params[:tag])
      end
      api_response_for_multiple :events, criteria.to_a
    end
  
    # return event with given id
    get '/:id' do
      api_response_for :event, Event.find(params[:id])
    end
  
    # create event with given parameters
    post do
      param_hash = JSON.parse(request.body.read)
      event = Event.create(param_hash)
      error 400 unless event.valid?
      {:id => event._id.to_s}.to_json
    end
  end
  
  namespace '/tags' do
    get do
      api_response_for_multiple :tags, Event.tags_with_counts
    end
  end
end

get('/') { 'Hello world!' }
