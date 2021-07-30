# ticket_generator.py
#
# Purpose: This file is unused. It is superceded by the generate.py script.
# I'm keeping it for future reference, for now
# Author: Jeff Davies (mailto:jeff.davies@datastax.com)
#
import random
import uuid
import datetime
import sys
from flight import Flight
from flight_generator import FlightGenerator
from name_generator import NameGenerator
from ticket import Ticket
from baggage import Baggage
class TicketGenerator:

    def __init__(self):
        self.x = 4

    @staticmethod
    def random_carousel():
        carousel_num = random.randrange(1,15, 1)
        return "%02d" % carousel_num

# Parse the command line arguments
numArgs = len(sys.argv)
if(numArgs == 2 and sys.argv[1] == 'tickets'):
    print("Ticket Generator!")
    start_time = datetime.datetime.now()
    print("Started at: ", start_time)
    name_gen = NameGenerator()
    flight_gen = FlightGenerator()
    ticket_gen = TicketGenerator()
    print("Creating the ticket.csv and the baggage.csv file. This will take a while!")
    with open('../database/ticket.csv', 'w') as ticket_file:
        with open('../database/baggage.csv', 'w') as baggage_file:
            # Write the csv file header
            ticket_file.write(Ticket.csv_header())
            # Write the csv file header
            baggage_file.write(Baggage.csv_header())

            for flight_index in range(len(flight_gen.flights)):
                flight = flight_gen.flights[flight_index]
                carousel = ticket_gen.random_carousel()
                # Generate 100 tickets for each flight
                for x in range(100):
                    ticket_id = uuid.uuid4()
                    passenger_id = uuid.uuid4()
                    passenger_name = name_gen.random_name()
                    flight_id = flight.flight_id
                    origin_city = flight.origin_city
                    destination_city = flight.destination_city
                    departure_time = flight.departure_time
                    departure_gate = flight.departure_gate
                    checkin_time = ''
                    ticket = Ticket(ticket_id, passenger_id, passenger_name, flight_id, origin_city, destination_city, departure_time, departure_gate, checkin_time, carousel)
                    ticket_file.write(ticket.as_csv())
                    
                    # Ok, are there any bags for this customer? Write out a random 
                    # number of bags for each ticket from 0 to 3
                    num_bags = random.randrange(0, 3, 1)
                    for bag in range(num_bags):
                        if(num_bags > 0):
                            baggage_id = uuid.uuid4()
                            bag = Baggage(baggage_id, ticket_id, passenger_id, passenger_name, '', flight_id, origin_city, destination_city, carousel)
                            baggage_file.write(bag.as_csv())
                # Every 30 flights show that we're still alive an working away!
                if (flight_index % 30 == 0):
                    print('.', end = '')

    finish_time = datetime.datetime.now()
    print("Creation completed at: ", finish_time)
    print("Elapsed time: ", finish_time - start_time, "\n\n")
    print("Both files were saved in the projects database/ directory")