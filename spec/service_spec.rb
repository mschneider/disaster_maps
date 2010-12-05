require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Service' do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before(:each) do
    Event.destroy_all
    @event = Factory.create(:event)
  end

  describe 'GET /api/v1/events/:id' do
    it 'should return event by id' do
      get "/api/v1/events/#{@event._id.to_s}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)['event']
      attributes['title'].should == @event.title
    end

    it 'should return a 404 for an event that doesn\'t exist' do
      get '/api/v1/events/4cfa7d260f2abc14c5000002'
      last_response.status.should == 404
    end
    
    it 'should return 404 for an invalid event id' do
      get '/api/v1/events/1'
      last_response.status.should == 404
    end
  end

  describe 'GET /api/v1/events*?geojson=true' do
    it 'should return events as geojson'
    it 'should return a single event as geojson'
  end

  describe 'GET /api/v1/events' do
    it 'should return events within a valid radius' do
      get '/api/v1/events?within_radius=[[73.1646,35.6842],5]'
      last_response.should be_ok
      JSON.parse(last_response.body).size.should > 0
    end

    it 'should return 404 if there are no events within a given radius' do
      get '/api/v1/events?within_radius=[[0,0],1]'
      last_response.status.should == 404
    end

    it 'should return events within a valid bbox' do
      get '/api/v1/events?bbox=[[73.0646,35.6842],[74.3033,36.2907]]'
      last_response.should be_ok
      JSON.parse(last_response.body).size.should > 0
    end

    it 'should return 404 if no event inside the bbox area is found' do
      get '/api/v1/events?bbox=[[1,2],[3,4]]'
      last_response.status.should == 404
    end
    
    it 'should return events within a valid blist' do
      get '/api/v1/events?blist=35.6842,73.0646,36.2907,74.3033'
      last_response.should be_ok
      JSON.parse(last_response.body).size.should > 0
    end

    it 'should return 404 if no event inside the blist area is found' do
      get '/api/v1/events?blist=[1,2,3,4]'
      last_response.status.should == 404
    end

    it 'should return events tagged with the given tag' do
      get '/api/v1/events?tag=bridge'
      last_response.should be_ok
      JSON.parse(last_response.body)['events'].first.should have_key('tags')
    end

    it 'should return a 404 if no event with the given tag is found' do
      get '/api/v1/events?tag=not_an_actual_tag'
      last_response.status.should == 404
    end
  end
  
  describe 'GET /api/v1/tags' do
    
    before(:each) do
      @another_event = Factory.create(:another_event)
    end
    
    it 'should return all tags' do
      get '/api/v1/tags'
      last_response.should be_ok
      counts = JSON.parse(last_response.body)['tags']
      counts.should == [
        { 'name' => 'bridge',               'count' => 2},
        { 'name' => 'construction',         'count' => 1},
        { 'name' => 'cut-off-supply-route', 'count' => 1}
      ]
    end
  end

  describe 'POST /api/v1/events' do
    it 'should create an event and read it afterwards' do
      parameter_hash =  {
        'title' => 'House destroyed',
        'description' => 'House belonging to Mr Karzai was completely destroyed, family homeless',
        'location' => [73.2, 36.2],
        'tags' => %w(homeless bridge cut-off-supply-route)
      }
      post '/api/v1/events', parameter_hash.to_json
      last_response.should be_ok
      new_event = Event.find(JSON.parse(last_response.body)['id'])
      new_event.should_not be_nil
    end
    
    it 'should return 400 if the event has no tags' do
      post '/api/v1/events', {'location' => [73.2, 36.2]}.to_json
      last_response.status.should == 400
    end
    
    it 'should return 400 if the event has no location' do
      post '/api/v1/events', {'tags' => %w(House destroyed)}.to_json
      last_response.status.should == 400
    end
    
    it 'should return 400 if the event has invalid attributes' do
      post '/api/v1/events', {'title' => 'a title', 'invalid_key' => 'value'}.to_json
      last_response.status.should == 400
    end
  end
  
  describe 'GET /api/v1/markers' do
    it 'should return list of markers' do
      get '/api/v1/markers'
      last_response.should be_ok
      markers = JSON.parse(last_response.body)
      markers.should_not be_nil
      markers.size.should > 0
    end
  end
  
  describe 'GET /markers/fire.png' do
    it 'should return marker fire' do
      get '/markers/fire.png'
      last_response.should be_ok
    end
  end

end
