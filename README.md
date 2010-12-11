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

- `GET /api/v1/event/$` returns the event with the given id
- `GET /api/v1/events` returns all events as json array. you can specify filters via the GET-parameters `tag`, `bbox` and `within_radius`.
- `GET /api/v1/markers` returns all available markers as json array
- `GET /api/v1/tags` returns all tags with their occurrence count as json array

### Example Calls

`$ curl "http://localhost:9292/api/v1/events"
{"events":[{"_id":"4cfb57f006f6e6a699000001","description":"Villiage of Balti, Near Gligit is cut off from the supply route due to the collapsed bridge","location":[73.3,36.2],"tags":["bridge","cut-off-supply-route"],"title":"Bridge collapsed"},{"_id":"4cfb57f006f6e6a699000002","description":"House belonging to Mr Karzai was completely destroyed, family homeless","location":[70.1,35.1],"tags":["house","destroyed"],"title":"House destroyed"}]}`

`$ curl "http://localhost:9292/api/v1/tags"
{"tags":[{"name":"bridge","count":1},{"name":"cut-off-supply-route","count":1},{"name":"destroyed","count":1},{"name":"house","count":1}]}`

## Attribution

Maps Icons are cc-by-sa by Nicolas Mollet: http://code.google.com/p/google-maps-icons/

## Team
    Derjoo http://twitter.com/derjoo
    Engin Kurutepe http://fifteenjugglers.com
    Florian Holzhauer http://fholzhauer.de
    Klas Kalass http://freiheit.com
    Max Schneider http://twitter.com/m_schneider
    Shoaib Burq http://geospatial.nomad-labs.com
