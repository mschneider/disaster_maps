# Disaster Maps

API for sending data on events from the field

## Open Tasks

### Markers

#### 1: Meaningfull Marker Icons
We need Marker Icons for Events like:
* Construction
* Water supply
* Food supply
* Destruction
* anything else you can come up with
place them into /public/marker/

#### 1: Marker index
The User should select between these given Markers.
Therefore we need a Model validation accepting only Markers present on the server.
Try listing the Directory /public/marker/ on class creation of Event.
And then something like validates_within.

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

