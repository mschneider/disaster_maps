require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Service' do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  before(:each) do
    # Event.destroy_all
    @event = Factory.stub(:event)
  end

  describe 'GET /api/v1/events/:id' do
    it 'should return event by id' do
      Event.expects(:find_by_id).with(1).returns(@event)
      get '/api/v1/events/1'
      last_response.should be_ok
    end
  end

  describe 'GET /api/v1/tags/:tag/events' do
    it 'should return events by tag' do
      Event.expects(:find).with(:tag => 'bridge').returns([@event])
      get '/api/v1/tags/bridge/events'
      last_response.should be_ok
      JSON.parse(last_response.body).first.should have_key('tags')
    end
    
    it 'should return a 404 for an event that doesn\'t exist'
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
    it 'should create an event' do
      parameter_hash =  {
        "title" => 'House destroyed',
        "description" => 'House belonging to Mr Karzai was completely destroyed, family homeless',
        "location" => [73.2, 36.2],
        "tags" => %(homeless)
      }
      Event.expects(:create).with(parameter_hash)
      post '/api/v1/events', :event => parameter_hash.to_json
      last_response.should be_ok
      # id = JSON.parse(last_response.body)['id']
      #      get "/api/v1/events/#{id}"
      #      attributes = JSON.parse(last_response.body)
      #      attributes['title'].should == 'House destroyed'
      #      attributes['description'].should == 'House belonging to Mr Karzai was completely destroyed, family homeless'
    end
  end
end
