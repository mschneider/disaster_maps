require File.dirname(__FILE__) + '/../service'
require 'spec'

set :environment, :test

def app
  Sinatra::Application
end

describe 'service' do
  before(:each) do
    Event.destroy_all
    event = Event.create(
      :title => 'Bridge collapsed',
      :description => 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge',
      :location => [73.3, 36.2],  #lon, lat : think x,y
      :tags => %w(bridge) )
  end

  describe 'GET /api/v1/events/:id' do
    it 'should return event by id'
  end

  describe 'GET /api/v1/events/:tag' do
    it 'should return events by tag'

    it 'should return a 404 for an event that doesn\'t exist'
  end

  describe 'GET /api/v1/events/:bounds' do
    it 'should return events by tag' do
      get '/api/v1/events/73.0646,35.6842,74.3033,36.2907'
    end
  end

  describe 'GET /api/v1/events/:location' do
    it 'should return events by point location' do
      get '/api/v1/events/73.3,36.2'
    end
  end

  describe 'POST /api/v1/events' do
    it 'should create an event' do
      post '/api/v1/events', {
        :title => 'House destroyed',
        :description => 'House belonging to Mr Karzai was completely destroyed, family homeless',
        :location => [73.2, 36.2],
        :tags => %(homeless)
      }.to_json
      last_response.should be_ok
      id = JSON.parse(last_response.body)['id']
      get "/api/v1/events/#{id}"
      attributes = JSON.parse(last_response.body)
      attributes['title'].should == 'House destroyed'
      attributes['description'].should == 'House belonging to Mr Karzai was completely destroyed, family homeless'
    end
  end
end