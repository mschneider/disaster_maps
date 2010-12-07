# Pakistan
lon=73.2+rand(2)
lat=36.2+rand(2)

# Betahaus, Berlin
lon=(13.4131108+rand(100)/10000.0 - 0.00005)
lat=(52.5024222+rand(100)/10000.0 - 0.00005)

# Rosenthaler Platz
lon=(13.4015393+rand(100)/10000.0 - 0.00005)
lat=(52.5297988+rand(100)/10000.0 - 0.00005)

markers= [
'/markers/accident.png',
'/markers/bomb.png',
'/markers/explosion.png',
'/markers/fire.png',
'/markers/flood.png',
'/markers/planecrash.png',
'/markers/radiation.png',
'/markers/revolution.png',
'/markers/strike.png'
]

events = [
  { 
    :marker => '/markers/flood.png', 
    :tags => ["crops", "livestock", "homes", "water contamination"],
    :description => "All crops under water. Livestock dead. Risk of water contamination"
  },

  { 
    :marker => '/markers/accident.png', 
    :tags => ["bridge", "broken-supply", "food-drop", "medicine-drop"], 
    :description => "The bridge was swept by the force of the flow. The village of Balti and its inhabitants require food and medical drops"
  },

  { 
    :marker => '/markers/strike.png', 
    :tags => ["riot", "food-shortages"], 
    :description => "Food drops urgently required to overcome the food shortage."
  }
]

while true
markers.each do |marker|
  lon=(13.4015393+rand(100)/10000.0 - 0.00005)
  lat=(52.5297988+rand(100)/10000.0 - 0.00005)
  i = rand(3)

  cmd = "curl -d \
\'{\"marker\":\"#{events[i][:marker]}\",\
\"description\":\"#{events[i][:description]}\",\
\"location\":[#{lon},#{lat}],\
\"tags\":#{events[i][:tags]}}\' \
-H \'Content-Type: application/json\' http://192.168.1.110:9292/api/v1/events"

  puts cmd
  system(cmd)
  # sleep(5)
end
end