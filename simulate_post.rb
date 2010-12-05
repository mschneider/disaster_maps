# lon=73.2+rand(2)
# lat=36.2+rand(2)
# Berlin

markers= ['/markers/accident.png',
'/markers/bomb.png',
'/markers/explosion.png',
'/markers/fire.png',
'/markers/flood.png',
'/markers/planecrash.png',
'/markers/radiation.png',
'/markers/revolution.png',
'/markers/strike.png']


markers.each do |marker|
  lon=(13.4113999+rand(100)/100.0 - 0.5)
  lat=(52.5234051+rand(100)/100.0 - 0.5)
  
  cmd = "curl -d \'{\"marker\":\"#{marker}\",\"description\":\"House belongestroyed, family homeless\",\"location\":[#{lon},#{lat}],\"tags\":[\"homeless\",\"bridge\",\"cut-off-supply-route\"]}\' -H \'Content-Type: application/json\' http://192.168.1.63:9292/api/v1/events"

  puts cmd
  system(cmd)
  # sleep()
end