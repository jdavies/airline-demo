# ReadMe.md - Database

This folder contains the database scripts

## Connection Info

You may find it easier to create a shell script that exports the connection info for your database. I maintain one of these for each database that I work with so I can quickly switch between them when I use my local command line tools.

```sh
export ASTRA_DB_ID=\<your DB ID\>
export ASTRA_DB_REGION=us-west1
export ASTRA_DB_KEYSPACE=airline
export ASTRA_DB_APPLICATION_TOKEN=\<app_token\>
```

You can find the app token in the shared GoogleDrive folder for this demo

## Document API

The document API uses the namesspace ```customers``` to store customer documents based n the customer ID.

The curl call to create this namespace is:

```sh
curl -X POST "https://79f93f84-e12a-4a48-b092-2db9ec48d446-us-west-2.apps.astra.datastax.com/api/rest/v2/namespaces/airline/collections" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:<REDACTED>" -H  "Content-Type: application/json" -d "{\"name\" : \"customers\"}"
```

Here is the curl call to put the entire document:

```sh
curl -X PUT "https://79f93f84-e12a-4a48-b092-2db9ec48d446-us-west-2.apps.astra.datastax.com/api/rest/v2/namespaces/airline/collections/customers/33330000-1111-1111-1111-000011110000" -H  "accept: application/json" -H  "X-Cassandra-Token: AstraCS:<REDACTED>" -H  "Content-Type: application/json" -d "{    \"id\": \"33330000-1111-1111-1111-000011110000\",    \"club_id\": 12355,    \"club_membership\" : \"100K\",    \"club_joined\": \"2012-04-23T18:25:43.511Z\",    \"club_expiration\": \"2021-10-23T18:25:43.511Z\",    \"contact\" : {        \"cell_phone\": \"+1 555-555-5555\",        \"work_phone\": \"+1 555-555-5555\",        \"email\" : [\"demo@datastax.com\", \"john2159@somebiz.com\"],        \"opt_in\" : true,        \"home_address\" : \"100 Main St, Palo Alto, CA 95005\",        \"work_address\": \"100 Main St, Palo Alto, CA 95005\"    },    \"club_checkins\" : [        {\"checkin_date\": \"2012-04-23T18:25:43.511Z\"}    ],    \"flight_history\": {        \"domestic\" : [            {                \"ticket\" : \"68780000-1111-1111-1111-000011110000\",                \"flight\" : \"ABC0214\",                \"bags_checked\" : 2,                \"miles_earned\" : 1795,                \"fight_date\" : \"2012-04-23T18:25:43.511Z\"            },            {                \"ticket\" : \"68780000-1111-1111-1111-000011110000\",                \"flight\" : \"ABC0216\",                \"bags_checked\" : 1,                \"miles_earned\" : 803,                \"fight_date\" : \"2015-12-23T07:25:43.511Z\"            }        ],        \"international\" : [            {                \"ticket\" : \"68780000-1111-1111-1111-000011110000\",                \"flight\" : \"ABC9203\",                \"bags_checked\" : 2,                \"miles_earned\" : 3458,                \"fight_date\" : \"2013-06-01T06:25:43.511Z\"            }        ]    }}"
```
