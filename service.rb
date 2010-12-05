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
#require File.expand_path('config/confidentials', settings.root)
set :db_config_file, File.expand_path('config/mongoid.yml', settings.root)
set :db_config, YAML.load_file(settings.db_config_file)[settings.environment.to_s]
Mongoid.configure { |c| c.from_hash(settings.db_config) }

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
        puts bounding_box.inspect
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
      event = Event.create(param_hash)
      error 400 unless event.valid?
      Pusher['channel_test'].trigger('create', api_response_for(:event, event))
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

post '/user_images/:filename' do
  filename = File.join('public','user_images', params[:filename])
  datafile = params[:data]
# "#{datafile[:tempfile].inspect}\n"
  File.open(filename, 'wb') do |file|
    file.write(datafile[:tempfile].read)
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
  # berlin
  Event.create({
    'title' => 'House destroyed',
    'description' => 'House belonging to Mr Karzai was completely destroyed, family homeless',
    'location' => [13.412151,52.503002],
    'tags' => %w(house destroyed)
  })
  Event.create({
    'title' => 'Bridge collapsed',
    'description' => 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge',
    'location' => [13.417,52.50400],
    'tags' => %w(house destroyed)
  })
  error 400 unless e1.valid? && e2.valid?
  'success'
end

get('/') { 'Hello world!' }
