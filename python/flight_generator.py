# flight_generator.py
#
# Purpose: This file is unused. It is superceded by the generate.py script.
# I'm keeping it for future reference, for now
# Author: Jeff Davies (mailto:jeff.davies@datastax.com)
#
import sys
import random
from flight import Flight

class FlightGenerator:
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

    # Thus list will hold every combination of flights
    flights = []

    # Class constructor
    def __init__(self):
        # Seed the random number generator with the current time
        random.seed()

        flight_number = 100

        # Create 10 flights from every city to every other city
        for origin_city_index in range(len(self.cities)):
            # origin_city_index is the index of our origin city
            origin_city = self.cities[origin_city_index]
            for destination_city_index in range(len(self.cities)):
                # Dont create tickets to the same city we are departing
                if(origin_city_index != destination_city_index):
                    destination_city = self.cities[destination_city_index]
                    # Now create 10 flights between these cities for today
                    for x in range(10):
                        flight_id = "ABC%04d" % flight_number
                        flight_number = flight_number +1
                        departure_time = FlightGenerator.create_departure_time(x)
                        departure_gate = FlightGenerator.create_departure_gate(x)
                        flight = Flight(flight_id, origin_city, destination_city, departure_time, departure_gate)
                        self.flights.append(flight)

        # Show 5 flights to sanity check
        # for x in range(5):
        #     flight = self.flights[x]
        #     flight.print()
    # Based on the hour offset, return a text string in the format of 10:00 AM
    @staticmethod
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

    # Based on the hour offset, return a text string in the format of 10:00 AM
    @staticmethod
    def create_departure_gate(hour_offset):
        gate = "A %02d" % (hour_offset + 1)
        return gate
            

    def random_flight(self):
        flight_index = random.randrange(0,len(self.flights), 1)
        return self.flights[flight_index]

numArgs = len(sys.argv)
if(numArgs == 2 and sys.argv[1] == 'flights'):
    print("FlightGenerator invoked with %d arguments" %numArgs)
    print("Flight Generator!")
    print("Creating the city.csv file...")
    flight_gen = FlightGenerator()
    with open('../database/city.csv', 'w') as city_file:
        city_file.write("name\n")
        for origin_city_index in range(len(flight_gen.cities)):
            origin_city = flight_gen.cities[origin_city_index]
            city_file.write(origin_city + "\n")

    print("Creating the flight_by_id.csv file...")
    with open('../database/flight_by_id.csv', 'w') as flight_file:
        flight_file.write("id,origin_city,destination_city,departure_time,departure_gate\n")
        for flight_index in range(len(flight_gen.flights)):
            flight = flight_gen.flights[flight_index]
            flight_file.write(f"{flight.flight_id},{flight.origin_city},{flight.destination_city},{flight.departure_time},{flight.departure_gate}\n")

    print("Both files were saved in the projects database/ directory")