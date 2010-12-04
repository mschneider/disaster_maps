require File.join(File.dirname(__FILE__), '..', 'service.rb')

require 'sinatra'
require 'rack/test'
require 'rspec'
require 'mocha'
require 'factory_girl'
require File.join(File.dirname(__FILE__), 'factories.rb')

set :environment, :test

Rspec.configure do |config|
  config.mock_with :mocha
end