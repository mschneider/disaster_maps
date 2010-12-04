FactoryGirl.define do
  factory :event do
    id          1
    title       'Bridge collapsed'
    description 'Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge'
    location    [73.3, 36.2]
    tags        %w(bridge)
  end
end