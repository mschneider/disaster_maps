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
    # content_type 'application/json', :charset => 'utf-8'
    pass unless resource
    { model => resource }.to_json
  end
  def api_response_for_multiple(model, resources)
    # content_type 'application/json', :charset => 'utf-8'
    pass if resources.empty?
    { model => resources }.to_json
  end
end

error BSON::InvalidObjectId do
  error 404
end

namespace '/api/v1' do
  namespace '/events' do
  
    # return list of events
    get do
      criteria = Event.find(:all)
      if params[:blist]
        bounding_list = JSON.parse(params[:blist])
        bounding_box = [[bounding_list[0], bounding_list[1]], [bounding_list[2], bounding_list[3]]]
        criteria = criteria.where(:location.within => {"$box" => bounding_box})
      end
      if params[:bbox]
        bounding_box = JSON.parse(params[:bbox])
        criteria = criteria.where(:location.within => {"$box" => bounding_box})
      end
      if params[:within_radius]
        center_and_radius = JSON.parse(params[:within_radius])
        criteria = criteria.where(:location.within => {"$center" => center_and_radius})
      end
      if params[:tag]
        criteria = criteria.where(:tags => params[:tag])
      end
      api_response_for_multiple :events, criteria.to_a
    end
  
    # create event with given parameters
    post do
      param_hash = JSON.parse(request.body.read)
      event = Event.create(param_hash)
      error 400 unless event.valid?
      {:id => event._id.to_s}.to_json
    end
      
    # return event with given id
    get '/:id' do
      api_response_for :event, Event.find(params[:id])
    end

  end
  
  namespace '/tags' do
    get do
      api_response_for_multiple :tags, Event.all_tags
    end
  end
  
  namespace '/markers' do
    get do
      api_response_for_multiple :markers, Event.all_markers
    end
  end
end

get '/seed' do
  Event.destroy_all
  e1 = Event.create({
    'title' => 'Bridge collapsed',
    'description' => 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge',
    'location' => [73.3, 36.2],
    'marker' => '/markers/fire.png',
    'tags' =>  %w(bridge cut-off-supply-route)
  })
  e2 = Event.create({
    'title' => 'House destroyed',
    'description' => 'House belonging to Mr Karzai was completely destroyed, family homeless',
    'location' => [70.1, 35.1],
    'marker' => '/markers/accident.png',
    'tags' => %w(house destroyed)
  })
  error 400 unless e1.valid? && e2.valid?
  'success'
end

get('/') { 'Hello world!' }
