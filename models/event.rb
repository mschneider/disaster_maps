class Event
  include Mongoid::Document
  field :title
  field :description
  field :created_at,  :type => Date
  field :updated_at,  :type => Date
  field :occurred_at, :type => Date
  field :tags, :type => Array
  field :location, :type => Array
  index [[ :location, Mongo::GEO2D ]], :min => 200, :max => 200
  
  validates_presence_of :title
  validates_presence_of :location
end