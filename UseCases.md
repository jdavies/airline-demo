# Use Cases

## Table of Contents

[Overview](#overview)

[Use Case Descriptions](#use-case-descriptions)

[Use Case: Buy Ticket](#use-case-buy-ticket)

1. [Call: Get Cities](#call-get-cities)
2. [Call: Get Flights](#call-get-flights)
3. [Call: Buy Ticket](#call-but-ticket)

[Use Case: Check-In](#use-case-check-in)

1. [Call: Update Ticket](#call-update-ticket)
2. [Call: Create Baggage](#call-create-baggage)

[Use Case: Baggage Claim](#use-cse-baggage-claim)

1. [Call: Get Baggage Records](#call-get-baggage-records)

[Behind the Scenes](#behind-the-scenes)

[Code Repository](#code-pepository)

## Overview

This hackathon project will demonstrate using Astra for an airline. It will support an application that allows the end customer to check in for a flight, check their bags at the ticketing counter, and be guided to the departure gate. Upon arrival at the destination airport, the customer will receive an email or push notification on which carousel their bags can be picked up.

## Use Case Descriptions

The demo will incorporate the following use cases.

1. **Login** - The end user can log into the application
2. Buy Ticket - The user can buy the ticket in the app. We will allow the user to select from a list of cities for the origin and destination
3. Ticket Check-In - The user can check in for their flight and hand off their bags at the ticketing counter.
4. The Flight - Not really a use case, but we need some way to show that the user has flown to their destination
5. Baggage Claim - When the user arrives, they receive a notification/email telling them which carousel their baggage is at.
6. Reset Data - Not really a use case per se, but a handy feature that allows the user to "clean up" after they demo the system. This will delete all tickets for the logged in user and all baggage records.

### Use Case: Buy Ticket

There are a couple of calls that need to be made in this use case. The first thing you need to do is to get a list of cities that we serve. These values can then be used to populate a dropdown list. The user will use this infraction to find a flight between the origin and destination cities.
Call: Get Cities
This uses a v1 REST call for simplicity.
Request
curl -X GET "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v1/keyspaces/airline/tables/city/rows" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"
Response
{ "count": 65, "rows": [
    {"name": "Chicago IL"},
    {"name": "Mobile AL"},
    {"name": "York PA"}]
}
Call: Get Flights
Next you need to find the list of flights that serve the origin and destination city. Here is some sample CQL form finding the flights between Akron OH and Dallas TX:
select * from flight_by_city where origin_city = 'Akron OH' and destination_city = 'Dallas TX';
Request
Example where clause: {"origin_city": {"$eq": "Akron OH"}, "destination_city": {"$eq": "Dallas TX"}}

curl -X GET "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/flight_by_city?where=%7B%22origin_city%22%3A%20%7B%22%24eq%22%3A%20%22Akron%20OH%22%7D%2C%20%22destination_city%22%3A%20%7B%22%24eq%22%3A%20%22Dallas%20TX%22%7D%7D" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"

Response
{
  "count": 10,
  "data": [
    {
      "origin_city": "Akron OH",
      "departure_gate": "A 01",
      "id": "ABC0260",
      "destination_city": "Dallas TX",
      "departure_time": "6:00 AM"
    },
    {
      "origin_city": "Akron OH",
      "departure_gate": "A 02",
      "id": "ABC0261",
      "destination_city": "Dallas TX",
      "departure_time": "7:00 AM"
    },
    ...
  ]
}
Call: Buy Ticket
Now you have enough information to create (aka buy) a ticket. You can mock up credit card details if you wish. You will need to generate the ticket uuid on the client and submit it in the body of the POST call. Alternatively, you can probably get away with using the passenger_id (which is the id from the login table for the user) as the ticket_id too, but you can only do this once as any subsequent "buy ticket" calls will overwrite the ticket record. The call to create the ticket for the demo@datastax customer for flight ABC0260 is as follows:

Curl POST
curl -X POST "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/ticket" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED" -H  "Content-Type: application/json" -d "{    \"id\": \"33330000-1111-1111-1111-000011110000\",    \"checkin_time\": \"\",    \"departure_gate\": \"A 02\",    \"departure_time\": \"7:00 AM\",    \"destination_city\": \"Dallas TX\",    \"flight_id\" : \"ABC02060\",    \"origin_city\" : \"Akron OH\",    \"passenger_id\" : \"33330000-1111-1111-1111-000011110000\",    \"passenger_name\" : \"Demo\",    \"carousel\" : \"A 01\"}"
Request
Body
{
    "id": "33330000-1111-1111-1111-000011110000",
    "checkin_time": "",
    "departure_gate": "A 02",
    "departure_time": "7:00 AM",
    "destination_city": "Dallas TX",
    "flight_id" : "ABC02060",
    "origin_city" : "Akron OH",
    "passenger_id" : "33330000-1111-1111-1111-000011110000",
    "passenger_name" : "Demo",
    "carousel" : "A 01"
}
When you do this for real, be sure to copy the carousel field from the flight record to the ticket record.

Response
Body
{
  "id": "33330000-1111-1111-1111-000011110000"
}
The id field that is returned is the ticket id. You will want to keep track of that also.
Use Case: Check-In
The next step in the demo is to have the user checkin for their flight, possibly dropping off some bags at the same time. All we really do here is update the "checkin_time" field for the ticket and then create the number of checked bags records (which can be set to 0, but a value of 1 - 3 makes for a better demo).
First we update the ticket with the check in time.
Call: Update Ticket
Request
Curl
curl -X PUT "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/ticket/33330000-1111-1111-1111-000011110000" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED" -H  "Content-Type: application/json" -d "{\"checkin_time\" : \"07:15 AM\"}"

Body
{ "checkin_time" : "07:15 AM" }
Response
Body
{
  "data": {
    "checkin_time": "07:15 AM"
  }
}
Call: Create Baggage
You will have to perform this call for each bag that the user wants to check. Again, you will need to generate a uuid for each bag being checked in. In this example I'm reusing the Demo user ID as the uuid for the baggage record also.
Request
Curl
curl -X POST "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/baggage" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED" -H  "Content-Type: application/json" -d "{\"flight_id\":\"ABC0260\", \"id\" : \"33330000-1111-1111-1111-000011110000\", \"carousel\" : \"A 01\", \"destination_city\" : \"Dallas TX\", \"image\" : \"\", \"origin_city\" : \"Akron OH\", \"passenger_id\" : \"33330000-1111-1111-1111-000011110000\", \"passenger_name\" :\"Demo\", \"ticket_id\" :\"33330000-1111-1111-1111-000011110000\"}"

Body
{"flight_id":  "ABC0260",
 "id" : "33330000-1111-1111-1111-000011110000",
 "carousel" : "A 01",
 "destination_city" : "Dallas TX",
 "image" : "",
 "origin_city" : "Akron OH",
 "passenger_id" : "33330000-1111-1111-1111-000011110000",
 "passenger_name" :"Demo",
 "ticket_id" :"33330000-1111-1111-1111-000011110000"
}
Again, be careful here. I'm reusing the Demo passenger ID for the baggage ID. I strongly suggest you create a uuid for each baggage record.
Response
{
  "id": "33330000-1111-1111-1111-000011110000",
  "flight_id": "ABC0260"
}
Use Case: Baggage Claim
The final step is to claim the bags. Here we will do a GET on the baggage table based on the passenger_id.
Call: Get Baggage Records
Sample CQL
select * from baggage where passenger_id = 33330000-1111-1111-1111-000011110000;

Request
Curl
curl -X GET "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/baggage?where=%7B%22passenger_id%22%3A%20%7B%22%24eq%22%3A%20%2233330000-1111-1111-1111-000011110000%22%7D%7D" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"

Swagger Where Clause
{"passenger_id": {"$eq": "33330000-1111-1111-1111-000011110000"}}
Response
{ "count": 1,
  "data": [
    {
      "image": "",
      "origin_city": "Akron OH",
      "passenger_id": "33330000-1111-1111-1111-000011110000",
      "id": "33330000-1111-1111-1111-000011110000",
      "carousel": "A 01",
      "ticket_id": "33330000-1111-1111-1111-000011110000",
      "destination_city": "Dallas TX",
      "passenger_name": "Demo",
      "flight_id": "ABC0260"
    }]
}
Use Case: Reset Data
This just deletes all tickets and baggage records associated with the logged in user.
Call - Get all Tickets for a Passenger
Request
Curl
curl -X GET "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/ticket?where=%7B%22passenger_id%22%3A%20%7B%22%24eq%22%3A%20%2211110000-1111-1111-1111-111100001111%22%7D%7D" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"

Swagger Where Clause
{"passenger_id": {"$eq": "33330000-1111-1111-1111-000011110000"}}
Response
{
  "count": 1,
  "data": [
    {
      "checkin_time": "06:44 PM",
      "origin_city": "Albuquerque NM",
      "passenger_id": "11110000-1111-1111-1111-111100001111",
      "departure_gate": "A 02",
      "id": "cc977481-85b7-4a33-937d-d262382a7d6b",
      "carousel": "C 06",
      "departure_time": "7:00 AM",
      "destination_city": "Austin TX",
      "passenger_name": "Jeff Davies",
      "flight_id": "ABC0791"
    }
  ]
}
Call - Delete Ticket
Request
Response
HTTP Response Code: 204

Call: Get All Baggage Records
Sample CQL
select * from baggage where passenger_id = 33330000-1111-1111-1111-000011110000;
Request
Curl
curl -X GET "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/baggage?where=%7B%22passenger_id%22%3A%20%7B%22%24eq%22%3A%20%2233330000-1111-1111-1111-000011110000%22%7D%7D" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"

Swagger Where Clause
{"passenger_id": {"$eq": "33330000-1111-1111-1111-000011110000"}}
Response
{ "count": 1,
  "data": [
    {
      "image": "",
      "origin_city": "Akron OH",
      "passenger_id": "33330000-1111-1111-1111-000011110000",
      "id": "33330000-1111-1111-1111-000011110000",
      "carousel": "A 01",
      "ticket_id": "33330000-1111-1111-1111-000011110000",
      "destination_city": "Dallas TX",
      "passenger_name": "Demo",
      "flight_id": "ABC0260"
    }]
}

Call - DELETE Baggage Record
Request
The URL needs to contain the flight_id followed by a slash and the baggage_id
Curl
curl -X DELETE "https://6f46c335-f1c1-4ee4-9d28-dd909821e7cf-us-west1.apps.astra.datastax.com/api/rest/v2/keyspaces/airline/baggage/ABC2072%2Cbc7cf4fc-1d04-4174-9309-61b80bf1d4b5" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:REDACTED"
Response
Behind the Scenes
While the demo will show the experience of a single user, the database itself will hold millions of records to better simulate real-world load.

Code Repository
GitHub: [https://github.com/jdavies/airline-demo](https://github.com/jdavies/airline-demo)
