# Disaster Maps

API for sending data on events from the field

## Open Tasks

### Markers

#### 1: Marker validation
Marker string should probably be validated to be without invalid chars like " or brackets in it.

### Image upload

#### 3: Image upload
Images should be possible to upload via iphone.
An Event has many Images URLs.
Images should be fetchable via the api or through the public folder - pick one implementation.

### Updating Events

#### 2: Update API
Events should be updatable via the API.
There should be an updated flag set in the database so we can distinguish between creation an updating in an post_save callback.

#### 4: Push Service
Updated events should be added queued to the push-service after updating or creating them.
The Push Service has clients registered.
The clients shuould be updated via Websockets and Iphone Push of the updated / create event.

#### optional 5: differential Push Service
Record the updated values on POST.
Invent a nice protocol.
Clients register to the push service with a certain view rectangle.
Only update those clients, which can view the Event.

## API Documentation

### Markers
"/api/v1/markers" returns list of available markers

### Example Calls

`$ curl "http://localhost:9292/api/v1/events"      
{"events":[{"_id":"4cfb57f006f6e6a699000001","description":"Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge","location":[73.3,36.2],"tags":["bridge","cut-off-supply-route"],"title":"Bridge collapsed"},{"_id":"4cfb57f006f6e6a699000002","description":"House belonging to Mr Karzai was completely destroyed, family homeless","location":[70.1,35.1],"tags":["house","destroyed"],"title":"House destroyed"}]}`

`$ curl "http://localhost:9292/api/v1/tags"  
{"tags":[{"name":"bridge","count":1},{"name":"cut-off-supply-route","count":1},{"name":"destroyed","count":1},{"name":"house","count":1}]}`

## Attribution
Maps Icons are cc-by-sa by Nicolas Mollet: http://code.google.com/p/google-maps-icons/
