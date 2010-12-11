require 'logger'
require 'yaml'
require 'mongoid'
require 'sinatra'
require 'sinatra/namespace'


before do
  headers['Access-Control-Allow-Origin'] = '*'
end
require 'pusher'

set :app_file, __FILE__
require File.expand_path('models/event', settings.root)
require File.expand_path('config/confidentials', settings.root)
set :db_config_file, File.expand_path('config/mongoid.yml', settings.root)
set :db_config, YAML.load_file(settings.db_config_file)[settings.environment.to_s]
Mongoid.configure do |c|
  c.from_hash(settings.db_config)
  c.logger = Logger.new(nil)
end
set :gridfs, Mongo::Grid.new(Mongoid.database)


helpers do
  def api_response_for(model, resource, geojson=false)
    # content_type 'application/json', :charset => 'utf-8'
    pass unless resource
    if geojson
      resources2geojson([resource]).to_json
    else
      { model => resource }.to_json
    end
  end

  def api_response_for_multiple(model, resources, geojson=false)
    # content_type 'application/json', :charset => 'utf-8'
    pass if resources.empty?
    if geojson
      resources2geojson(resources).to_json
    else
      { model => resources }.to_json
    end
  end

  def geojson_tmpl
    JSON.parse('{ "type": "FeatureCollection", "features": [{ "type": "Feature",
                  "geometry": {"type": "Point", "coordinates": [102.0, 0.5]} 
                }]}')
  end

  def resources2geojson(resources)
    geojson = geojson_tmpl
    geojson["features"] = resources.collect do |resource|
      resource2feature(resource)
    end
    geojson
  end

  def resource2feature(resource)
    geojson=geojson_tmpl
    feature = geojson["features"][0]
    feature["geometry"]["coordinates"] = resource.location
    feature["properties"] = resource.attributes
    feature
  end
end

error BSON::InvalidObjectId do
  error 404
end

before do
  headers['Access-Control-Allow-Origin'] = '*'
end

namespace '/api/v1' do
  namespace '/events' do
  
    # return list of events
    get do
      criteria = Event.find(:all)
      if params[:blist]
        bounding_list = params[:blist].split(',').map{ |c| c.to_f}
        bounding_box = [[bounding_list[1], bounding_list[0]], [bounding_list[3], bounding_list[2]]]
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
      if params[:geojson]
        api_response_for_multiple :events, criteria.to_a, geojson=true
      else
        api_response_for_multiple :events, criteria.to_a
      end
    end
  
    # create event with given parameters
    post do
      param_hash = JSON.parse(request.body.read)
      begin #workaround for mongoid madness
        event = Event.create(param_hash)
      rescue NoMethodError
        error 400
      end
      error 400 unless event.valid?
      Pusher['test_channel'].trigger('create', api_response_for(:event, event, geojson=true))
      {:id => event._id.to_s}.to_json
    end
      
    # return event with given id
    get '/:id' do
      api_response_for :event, Event.find(params[:id])
    end
    
    namespace '/:id/photos' do
      post do
        photo_id = settings.gridfs.put(params[:file][:tempfile], :filename => params[:caption]).to_s
        event = Event.find(params[:id])
        event.photos << photo_id
        error 400 unless event.save
        {:id => photo_id}.to_json
      end
    end
  end
  
  namespace '/photos' do
    get '/:id' do
      settings.gridfs.get(BSON::ObjectId(params[:id])).read
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
  require 'factory_girl'
  require File.join(File.dirname(__FILE__), 'spec', 'factories.rb')
  error 400 unless Factory.create(:explosion_event).valid? && Factory.create(:construction_event).valid?
  'Database successfully seeded.'
end

get '/' do
  'Hello world!'
end
