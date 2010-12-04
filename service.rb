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
  def event(resource)
    pass unless resource
    { :event => resource }.to_json
  end
  def events(resources)
    pass if resources.empty?
    { :events => resources }.to_json
  end
end

namespace '/api/v1' do

  # return list of events with given tag
  get('/tags/:tag/events') { events Event.find(:conditions => { :tags => params[:tag]})  }
  
  # return list of events in the given area or any area
  get('/events') do
    event_set = Event
    if params[:bbox]
      event_set = event_set.where(:location.within => {"$box" => JSON.parse(params[:bbox])})
    end
    if params[:tag]
      event_set = event_set.where(:tags => params[:tag])
    end
    events event_set.find()
  end
  
  # return event with given id
  get('/events/:id') { event Event.find(params[:id]) }
  
  
  post('/events') do
    event = Event.create(JSON.parse(request.body.read))
    400 unless event.valid?
    {:id => event._id.to_s}.to_json
  end
  
end

get('/') { 'Hello world!' }
