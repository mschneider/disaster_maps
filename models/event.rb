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
  
  def self.tags_with_counts
    tags = collection.map_reduce(
      """function() {
        this.tags.forEach(function(tag){
            emit(tag, 1);
        });
      }""",
      """function(key, values) {
        var count = 0;
        values.forEach(function(value){
          count += value;
        });
        return count;
      }"""
    )
    tags.find().to_a.map!{|item| { :name => item['_id'], :count => item['value'].to_i } }
  end
end