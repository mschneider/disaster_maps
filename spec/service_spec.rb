require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Service' do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before :each do
    Event.destroy_all
    @explosion_event = Factory.create(:explosion_event)
  end

  describe 'GET /api/v1/events/:id' do
    it 'should return event by id' do
      get "/api/v1/events/#{@explosion_event._id.to_s}"
      last_response.should be_ok
      response_attributes = JSON.parse(last_response.body)['event']
      attributes = @explosion_event.attributes
      attributes[:_id] = attributes[:_id].to_s
      response_attributes.should == attributes
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
    
    before :each do
      Factory.create(:construction_event)
    end
    
    it 'should return all tags' do
      get '/api/v1/tags'
      last_response.should be_ok
      counts = JSON.parse(last_response.body)['tags']
      counts.should == [
        { 'name' => 'bridge',               'count' => 2},
        { 'name' => 'construction',         'count' => 1},
        { 'name' => 'cut-off-supply-route', 'count' => 1},
        { 'name' => 'explosion',            'count' => 1}
      ]
    end
  end

  describe 'POST /api/v1/events' do
    
    before :each do
      @construction_attributes = Factory.attributes_for(:construction_event)
    end
    
    it 'should create an event and return its id' do
      Pusher['test_channel'].stub(:trigger)
      post '/api/v1/events', @construction_attributes.to_json
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
    
    # it 'should return 400 if the event has invalid attributes' do
    #   post '/api/v1/events', @construction_attributes.merge('invalid_key' => 'value').to_json
    #   last_response.status.should == 400
    # end
  end
  
  describe 'POST /api/v1/events/:id/photos' do
    it 'should create a new photo associated to the event and return its id' do
      source_filename = 'public/markers/fire.png'
      post "/api/v1/events/#{@explosion_event._id}/photos", {
        'file' =>  Rack::Test::UploadedFile.new(source_filename, 'image/png'),
        'caption' => 'Photo of the explosion'
      }
      last_response.should be_ok
      new_photo_id = JSON.parse(last_response.body)['id']
      get "/api/v1/photos/#{new_photo_id}"
      last_response.should be_ok
      source_md5 = Digest::MD5.hexdigest(File.read(source_filename))
      upload_md5 = Digest::MD5.hexdigest(last_response.body)
      upload_md5.should == source_md5
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
