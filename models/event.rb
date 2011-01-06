class Event
  include Mongoid::Document
  
  field :tags, :type => Array
  field :location, :type => Array
  field :description
  field :marker
  field :photos, :type => Array
  
  index [[ :location, Mongo::GEO2D ]], :min => 200, :max => 200
  
  attr_protected :_id
  validates_presence_of :location
  validates_presence_of :tags
  after_save :rebuild_tags
  before_create :check_photos
  
  @@files = Dir.glob("public/markers/*.{jpg,png,gif}")
  @@files.each { |file| file['public/'] = '/' }
  def self.all_markers() @@files; end
      
  def self.all_tags()
    tags = Mongoid.master.collection('tags')
    tags.find().to_a.map!{|item| { :name => item['_id'], :count => item['value'].to_i } }
  end
    
  def rebuild_tags()
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

  def check_photos
    return true if self.photos.blank?
    self.photos = self.photos.collect do |params|
      begin
        settings.gridfs.put(params['file']['tempfile'].join, :filename => params['caption']).to_s
      rescue Exception => e
        self.errors.add(:base, "Error uploading file")
        return false
      end
    end
    return true
  end
end
