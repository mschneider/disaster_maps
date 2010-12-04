Factory.define :event do |e|
  e.id          1
  e.title       'Bridge collapsed'
  e.description 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge'
  e.location    [73.3, 36.2]
  e.tags        %w(bridge)
end