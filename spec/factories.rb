require 'faker'

class Defaults
  def self.title
    @_title ||= Faker::Lorem.words.join(' ')
  end
  def self.location
    @_location ||= [73.3, 36.2]
  end
end

Factory.define :event do |e|
  e.title       'Bridge collapsed'
  e.description 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge'
  e.location    [73.3, 36.2]
  e.tags        %w(bridge cut-off-supply-route)
end


Factory.define :another_event, :class => Event do |e|
  e.title       'Bridge rebuild'
  e.description 'Villiage of Balti, Near Gligit is conntected agaion to the supply route'
  e.location    [73.3, 36.2]
  e.tags        %w(bridge construction)
end