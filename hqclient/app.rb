require 'sinatra'

set :port, 5432
set :public, File.dirname(__FILE__) + '/target'

get '/' do
  'hello world'
end

