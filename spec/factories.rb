Factory.define :explosion_event, :class => Event do |e|
  e.tags        %w(bridge explosion cut-off-supply-route)
  e.location    [73.3, 36.2]
  e.description 'Village of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge'
  e.marker      '/markers/explosion.png'
end

Factory.define :construction_event, :class => Event do |e|
  e.tags        %w(bridge construction)
  e.location    [73.3, 36.2]
  e.description 'Villiage of Balti, Near Gligit is conntected agaion to the supply route'
  e.marker      '/markers/flood.png'
end