require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Service' do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before(:each) do
    Event.destroy_all
    @event = Factory.stub(:event)
    @db_event = Factory.create(:event)
  end

  describe 'GET /api/v1/events/:id' do
    it 'should return event by id' do
      get "/api/v1/events/#{@db_event._id.to_s}"
      last_response.should be_ok
      attributes = JSON.parse(last_response.body)['event']
      attributes['title'].should == @db_event.title
    end

    it 'should return a 404 for an event that doesn\'t exist' do
      get '/api/v1/events/4cfa7d260f2abc14c5000002'
      last_response.status.should == 404
      puts last_response.inspect
    end
  end

  describe 'GET /api/v1/events' do
    it 'should return events within a valid bbox' do
      get '/api/v1/events?bbox=[[73.0646,35.6842],[74.3033,36.2907]]'
      last_response.should be_ok
      JSON.parse(last_response.body).size.should == 1
    end

    it 'should return 404 if no event inside the area is found' do
      query_criteria = Object.new
      query_criteria.expects(:find).returns([])
      Event.expects(:where)
        .with(:location.within => {"$box" => [[1,2],[3,4]]} )
        .returns(query_criteria)

      get '/api/v1/events?bbox=[[1,2],[3,4]]'
      last_response.should_not be_ok
    end
  end

  describe 'GET /api/v1/tags/:tag/events' do
    it 'should return events by tag' do
      get '/api/v1/tags/bridge/events'
      last_response.should be_ok
      JSON.parse(last_response.body)['events'].first.should have_key('tags')
    end

    it 'should return a 404 for an tag that doesn\'t exist' do
      get '/api/v1/tags/not_an_actual_tag/events'
      last_response.should_not be_ok
    end
  end

  describe 'GET /api/v1/events/:bounds' do
    it 'should return events by tag' do
      pending
      get '/api/v1/events/73.0646,35.6842,74.3033,36.2907'
    end
  end

  describe 'GET /api/v1/events/:location' do
    it 'should return events by point location' do
      pending
      get '/api/v1/events/73.3,36.2'
    end
  end

  describe 'POST /api/v1/events' do
    it 'should create an event and read it afterwards' do
      parameter_hash =  {
        "title" => 'House destroyed',
        "description" => 'House belonging to Mr Karzai was completely destroyed, family homeless',
        "location" => [73.2, 36.2],
        "tags" => %w(homeless bridge cut-off-supply-route)
      }
      post '/api/v1/events', parameter_hash.to_json
      last_response.should be_ok
      new_event = Event.find(JSON.parse(last_response.body)['id'])
      new_event.should_not be_nil
    end
  end
end
