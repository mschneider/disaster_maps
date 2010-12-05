class Event
  include Mongoid::Document
  field :title
  field :description
  field :created_at,  :type => Date
  field :updated_at,  :type => Date
  field :occurred_at, :type => Date
  field :tags, :type => Array
  field :marker
  field :location, :type => Array
  index [[ :location, Mongo::GEO2D ]], :min => 200, :max => 200
  
  validates_presence_of :title
  validates_presence_of :location
  
  after_save :rebuild_tags
  
  def self.all_tags
    tags = Mongoid.master.collection('tags')
    tags.find().to_a.map!{|item| { :name => item['_id'], :count => item['value'].to_i } }
  end
  
  def self.all_markers
    @@files
  end

  @@files = Dir.glob("public/markers/*.{jpg,png,gif}")
  @@files.each do |file|
    file['public/'] = '/'
  end
  
  protected
  
  def rebuild_tags
    Event.collection.map_reduce(
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
      }""",
      # this behves like a materialzed view
      { :out => 'tags'}
    )
  end
end