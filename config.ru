#rack config

require 'rubygems'
require 'bundler'

require File.join(File.dirname(__FILE__), "service")

run Sinatra::Application