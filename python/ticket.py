# This represents a single ticket

class Ticket:
    def __init__(self, id, passenger_id, passenger_name, flight_id, origin_city, 
    destination_city, departure_time, departure_gate, checkin_time, carousel, bags_checked, miles_earned):
        self.id = id
        self.passenger_id = passenger_id
        self.passenger_name = passenger_name
        self.flight_id = flight_id
        self.origin_city = origin_city
        self.destination_city = destination_city
        self.departure_time = departure_time
        self.departure_gate = departure_gate
        self.checkin_time = checkin_time
        self.carousel = carousel
        self.bags_checked = bags_checked
        self.miles_earned = miles_earned

    def print(self):
        print("ticket: " + self.id + " for flight " + self.flight_id + " - From: " + self.origin_city + "  To: " + self.destination_city + 
            " departing at " + self.departure_time + " from gate " + self.departure_gate)

    # Return this record as a single line in a CSV file
    def as_csv(self):
        return f"{self.id},{self.passenger_id},{self.passenger_name},{self.flight_id},{self.origin_city}," + \
            f"{self.destination_city},{self.departure_time},{self.departure_gate},{self.checkin_time},{self.carousel},{self.bags_checked},{self.miles_earned}\n"
        
    # Return this record as a single line in a CSV file
    @staticmethod
    def csv_header():
        return "id,passenger_id,passenger_name,flight_id,origin_city," + \
            "destination_city,departure_time,departure_gate,checkin_time,carousel,bags_checked,miles_earned\n"

# create table ticket(
#     id uuid,
#     passenger_id uuid,
#     passenger_name text,
#     flight_id text,
#     origin_city text,
#     destination_city text,
#     departure_time timestamp,
#     departure_gate text,
#     checkin_time text,
#     carousel text,
#     bags_checked int.
#     miles_earned int,
#     PRIMARY KEY(id)
# );