# utils.py
#
# Purpose: Utility file to hold supporting functions
# Author: Jeff Davies (mailto:jeff.davies@datastax.com)
#
import sys, getopt
import datetime
import time
import random
import uuid
import credentials
import name_generator

from cassandra.cluster import Cluster, BatchStatement
from cassandra.auth import PlainTextAuthProvider
from cassandra.util import datetime_from_uuid1

# Seed the random number generator with the current time
random.seed()

session = None
cluster = None

def connectToAstra():
    print("Connecting toAstra...")
    start_time = datetime.datetime.now()
    global cluster
    global session
    cloud_config= {
            # Replace this value with the path to your file
            'secure_connect_bundle': './secure-connect-airline-demo.zip'
    }
    auth_provider = PlainTextAuthProvider(credentials.client_id, credentials.client_secret)
    cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
    session = cluster.connect()
    finish_time = datetime.datetime.now()
    # print("Time to connect to Astra: ", finish_time - start_time, "\n\n")
    session.set_keyspace('airline')
    print("connected!")
    return session

def disconnectFromAstra():
    print("Disconnecting from Astra")
    global cluster
    global session
    cluster.shutdown()
    cluster = None
    session = None

# Write a single CQL command to the database
def write_to_astra(session, cql):
    print('writing: ' + cql)
    if session is None:
        return None
    else:
        resultSet = session.execute(cql)
        return resultSet

# Convert the uuid1 timestamp to a standard posix timestamp
def get_posixtime(uuid1):
    assert uuid1.version == 1, ValueError('only applies to type 1')
    t = uuid1.time
    t = t - 0x01b21dd213814000
    t = t / 1e7
    return t


# Generate a date ranging from today to max_age days in the past
def generate_random_date(max_age = 120):
    todays_date = datetime.date.today()
    # print("today is " + str(todaysDate))
    date_range = random.randrange(0,max_age, 1)
    # print("dateRange = " + str(dateRange))
    new_date = todays_date - datetime.timedelta(days=date_range)
    # print("newDate = " + str(newDate))
    return new_date



# Given a timeuuid, generate a time slot string based on the hour of the day.
# Return values should be between "SLOT_00" and "SLOT_23"
def get_timeslot_from_timeuuid(the_uuid):
    time_slot = "SLOT_"
    based_on_uuid = False   # Set to True if you want it to match the record creating time
    if(based_on_uuid):
        dt_foo = datetime_from_uuid1(the_uuid)
        date_str = str(dt_foo)
        date_str = date_str.split('.')[0]
        d = datetime.datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S')
        time_slot += str(d.hour)
    else:
        hr = random.randrange(0,23, 1)
        time_slot += str(hr).zfill(2)
    return time_slot