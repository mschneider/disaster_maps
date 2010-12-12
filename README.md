# Disaster Maps

API for sending data on events from the field

## Open Tasks

### Markers

#### Marker validation
Marker string should probably be validated to not include invalid chars like " or brackets in it.

### Updating Events

#### Update API
Events should be updatable via the API.
Updated events should be queued to the push-service.

#### optional: differential Push Service
Record the updated values on POST.
Invent a nice protocol.
Clients register to the push service with a certain view rectangle.
Only update those clients, which can view the Event.

### Filtering Events

#### Filtering by multiple Tags at the same time
We should support filtering by tags using and/or/not to connect tags to an algebra-style expression.
The syntax should be easy to use.
Ideally the user doesn't need to know the syntax and just inputs a series of tags separated by spaces and eventually prefixed with a dash.
Example Usage:
`tag1 tag2 -tag3` should translate to (tag1 or tag2) and (not tag3).

### Event Descriptions

#### Markup in Event descriptions
Event descriptions should be possible to be formatted by the HQ.
At the same Time it should be possible to display only the essential informations.
Maybe something like Event embeds Document which has Title and Description.

#### PDF Export or similar
Parts or Collections of Events should be able to be exported as a complete report.

#### optional: Link with spreadsheets
Eg. total project costs associated with specific sites in the map, potentially sums for costs created by specific project categories or partner organisations.

## API Documentation

- `GET /api/v1/events/:id` Returns the Event with the given `id` as JSON.
- `GET /api/v1/events` Returns all Events as JSON array. You can specify filters via the GET-parameters. Available filters are: `tag`, `blist`, `bbox` and `within_radius`.
- `GET /api/v1/photos/:id` Returns the photo with the given `id`.
- `GET /api/v1/markers` Returns all available markers as JSON array.
- `GET /api/v1/tags` Returns all tags with their occurrence count as JSON array.
- `POST /api/v1/events` Creates a new event based on the JSON supplied in the request body. Returns the id wrapped in JSON.
- `POST /api/v1/events/:id/photos` Creates a new photo for the Event with the given `id` based on the JSON supplied in the request body. Returns the photo's id wrapped in JSON.

### Example Calls

    $ curl "http://localhost:9292/api/v1/events"
    {"events":[
      { "location":[73.3,36.2],
        "photos":[],
        "_id":"4d03d2d40cefed8655000001",
        "marker":"/markers/explosion.png",
        "tags":["bridge","explosion","cut-off-supply-route"],
        "description":"Village of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge"
      },
      { "location":[73.3,36.2],
        "photos":[],
        "_id":"4d03d2d40cefed8655000002",
        "marker":"/markers/flood.png",
        "tags":["bridge","construction"],
        "description":"Villiage of Balti, Near Gligit is conntected agaion to the supply route"
      }
    ]}
  
    $ curl "http://localhost:9292/api/v1/events/4d03d2d40cefed8655000001"
    {"event":{
      "location":[73.3,36.2],
      "photos":[],
      "_id":"4d03d2d40cefed8655000001",
      "marker":"/markers/explosion.png",
      "tags":["bridge","explosion","cut-off-supply-route"],
      "description":"Village of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge"
    }}

    $ curl "http://localhost:9292/api/v1/tags"
    {"tags":[
      {"name":"bridge","count":2},
      {"name":"construction","count":1},
      {"name":"cut-off-supply-route","count":1},
      {"name":"explosion","count":1}
    ]}
  
    $ curl "http://localhost:9292/api/v1/markers"
    {"markers":[
      "/markers/accident.png","/markers/bomb.png","/markers/explosion.png",
      "/markers/fire.png","/markers/flood.png","/markers/planecrash.png",
      "/markers/radiation.png","/markers/revolution.png","/markers/strike.png"
    ]}

## Attribution

Maps Icons are cc-by-sa by Nicolas Mollet: http://code.google.com/p/google-maps-icons/

## Team
Derjoo (http://twitter.com/derjoo)
Engin Kurutepe (http://fifteenjugglers.com)
Florian Holzhauer (http://fholzhauer.de)
Klas Kalass (http://freiheit.com)
Max Schneider (http://twitter.com/m_schneider)
Shoaib Burq (http://geospatial.nomad-labs.com)
