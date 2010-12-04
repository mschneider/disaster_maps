#rack config

require 'rubygems'
require 'bundler'

Bundler.require

require File.join(File.dirname(__FILE__), "server", "service")

run Sinatra::Application