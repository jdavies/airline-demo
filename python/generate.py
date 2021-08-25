# generate.py
#
# Purpose: Generates the CSV files for the airline demo.
# Author: Jeff Davies (mailto:jeff.davies@datastax.com)
#
import sys, getopt
import random
import uuid
import datetime

# IMPORTANT - You need to supply your own credentials.py file in the same
# folder as the generate_data.py file. This file should have the following 
# format:
# client_id = '<YOUR CLIENT ID>'
# client_secret = '<YOUR CLIENT SECRET>'
# token = '<YOUR TOKEN>'
# In this script, we don't make use of the token though, so you can omit it 
# in your credentials.py file.
import credentials
from flight import Flight
from ticket import Ticket
from baggage import Baggage
from name_generator import NameGenerator
from astra_utils import *

# Import the cassandra-driver
from cassandra.cluster import Cluster, BatchStatement
from cassandra.auth import PlainTextAuthProvider
from cassandra.util import datetime_from_uuid1


# An array of flight origin and destination cities. Some cities are commented out to reduce the number of possible flights
cities = [
    "Akron OH", "Albuquerque NM", "Amarillo TX", "Atlanta GA", "Atlantic City NJ", "Augusta GA", "Austin TX",
    "Bakersfield CA", "Baltimore MD", "Bangor ME", "Birmingham AL", "Boise ID", "Boston MA", 
    "Camden NJ", "Charleston SC", "Charlotte NC", "Chicago IL", "Dallas TX", 
    "Gettysburg PA", 
    "Hartford CT", "Houston TX", 
    "Jackson MS", "Jacksonville FL", "Jacksonville NC",
    "Kansas City KS", "Kansas City MO",
    "Lancaster PA", "Las Vegas NV", "Little Rock AR", "Los Angeles CA", "Louisville KY", "Lubbock TX",
    "Memphis TN", "Miami FL", "Mobile AL", "Montgomery AL",
    "New Haven CT", "New Orleans LA", "New York NY",
    "Orlando FL", 
    "Philadelphia PA", "Phoenix AZ", "Portland OR", "Portland ME", "Poughkeepsie NY", "Providence RI",
    "Raleigh NC", "Reno NV", "Richmond VA",
    "Sacramento CA", "Salem NH", "San Antonio TX", "San Diego CA", "San Francisco CA", "San Jose CA", "Savannah GA", "Seattle WA", "Shreveport LA",
    "Springfield MA",
    "Tampa FL", "Tucson AZ",
    "Washington DC", "Wilmington DE", "White Plains NY",
    "York PA"
]

# Create a departure time based on the hour offset, a value from 0 to 11
def create_departure_time(hour_offset):
    hour = 6 + hour_offset
    if(hour < 12):
        departure_time = "%d:00 AM" % hour
    else:
        if(hour == 12):
            departure_time = "%d:00 PM" % hour
        else:
            departure_time = "%d:00 PM" % (hour - 12)
    return departure_time

# Create a departure gate based on the hour offset, a value from 0 to 11
def create_departure_gate(hour_offset):
    gate = "A %02d" % (hour_offset + 1)
    return gate

# Returns a random carousel number for the flight.
# This represents the baggage carousel at the destination city
def random_carousel():
    carousel_num = random.randrange(1,15, 1)
    terminals = ["A", "B", "C"]
    terminal_num = random.randrange(0,3, 1)
    return terminals[terminal_num] + " %02d" % carousel_num

def create_all():
    name_gen = NameGenerator()
    print("Creating the city.csv file...")
    with open('../database/city.csv', 'w') as city_file:
        city_file.write("name\n")
        for origin_city_index in range(len(cities)):
            origin_city = cities[origin_city_index]
            city_file.write(origin_city + "\n")

    print("Creating the flight_by_id.csv, ticket.csv and baggage.csv files...")
    with open('../database/flight_by_id.csv', 'w') as flight_file:
        with open('../database/ticket.csv', 'w') as ticket_file:
            with open('../database/baggage.csv', 'w') as baggage_file:
                # Write the CSV header
                flight_file.write("id,origin_city,destination_city,departure_time,departure_gate,carousel\n")
                # Write the csv file header
                ticket_file.write(Ticket.csv_header())
                # Write the csv file header
                baggage_file.write(Baggage.csv_header())
                # Our starting flight number
                flight_number = 100

                # Create 10 flights from every city to every other city
                for origin_city_index in range(len(cities)):
                    # origin_city_index is the index of our origin city
                    origin_city = cities[origin_city_index]
                    for destination_city_index in range(len(cities)):
                        # Dont create tickets to the same city we are departing
                        if(origin_city_index != destination_city_index):
                            destination_city = cities[destination_city_index]
                            # Now create 10 flights between these cities for today
                            for x in range(10):
                                flight_id = "ABC%04d" % flight_number
                                flight_number = flight_number +1
                                departure_time = create_departure_time(x)
                                departure_gate = create_departure_gate(x)
                                carousel = random_carousel()
                                # print("Carousel " + carousel)
                                flight = Flight(flight_id, origin_city, destination_city, departure_time, departure_gate, carousel)
                                # flight.print()
                                flight_file.write(f"{flight.flight_id},{flight.origin_city},{flight.destination_city},{flight.departure_time},{flight.departure_gate},{flight.carousel}\n")

                                # For each flight create 100 tickets
                                for t in range(100):
                                    ticket_id = uuid.uuid4()
                                    passenger_id = uuid.uuid4()
                                    passenger_name = name_gen.random_name()
                                    checkin_time = ''
                                    num_bags = random.randrange(0, 3, 1)
                                    bags_checked = num_bags
                                    miles_earned = 500
                                    ticket = Ticket(ticket_id, passenger_id, passenger_name, flight_id, origin_city, destination_city, departure_time, departure_gate, checkin_time, carousel, bags_checked, miles_earned)
                                    ticket_file.write(ticket.as_csv())
                                    
                                    # Ok, are there any bags for this customer? Write out a random 
                                    # number of bags for each ticket from 0 to 3
                                    for bag in range(num_bags):
                                        if(num_bags > 0):
                                            baggage_id = uuid.uuid4()
                                            bag = Baggage(baggage_id, ticket_id, passenger_id, passenger_name, '', flight_id, origin_city, destination_city, carousel)
                                            baggage_file.write(bag.as_csv())

                                # Every 30 flights show that we're still alive an working away!
                                if (x % 30 == 0):
                                    print('.', end = '')

    print("All files were saved in the projects database/ directory")

# ***************
# * Main thread *
# ***************

# Seed the random number generator with the current time
random.seed()

create_all()

print("Generation finished!\n")

# Sample command
# python generate.py