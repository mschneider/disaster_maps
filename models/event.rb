class Event
  include Mongoid::Document
  field :title
  field :description
  field :created_at,  :type => Date
  field :updated_at,  :type => Date
  field :occurred_at, :type => Date
  field :tags
  field :location, :type => Array
  index [[ :location, Mongo::GEO2D ]], :min => 200, :max => 200
end