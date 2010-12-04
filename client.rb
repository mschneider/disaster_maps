require 'rubygems'
require 'typhoeus'
require 'json'

class Event
  class << self; attribute_accessor :base_url end

  def self.find_by_id(id)
    response =  Typhoeus::Request.get("#{base_ur}/api/v1/event/#{id}")
    if response.code == 200
      JSON.parse(respond.body)
    elsif response.code == 404
      nil
    else
      raise response.body
    end
  end

  def self.create(attributes)
    response = Typheous::Request.post("#{base_url}/api/v1/event", :body => attributes.to_json)
    if response.code == 200
      JSON.parse(response.body)
    else
      raise response.body
    end
  end
end
