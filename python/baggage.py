# This represents a single baggage record

# create table baggage(
#     id uuid,
#     ticket_id uuid,
#     passenger_id uuid,
#     passenger_name text
#     image text,
#     flight_id text, 
#     origin_city text, 
#     destination_city text,
#     carousel text,
#     PRIMARY KEY((ticket_id), passenger_id)
# );

class Baggage:
    def __init__(self, id, ticket_id, passenger_id, passenger_name, image, flight_id, origin_city, 
    destination_city, carousel):
        self.id = id
        self.ticket_id = ticket_id
        self.passenger_id = passenger_id
        self.passenger_name = passenger_name
        self.image = image
        self.flight_id = flight_id
        self.origin_city = origin_city
        self.destination_city = destination_city
        self.carousel = carousel


    def print(self):
        print("Baggage id: " + self.id + " for ticket: " + self.ticket_id + " for passenger " + self.passenger_name + " - From: " + self.origin_city + "  To: " + self.destination_city + 
            " is on carousel " + self.carousel)

    # Return this record as a single line in a CSV file
    def as_csv(self):
        return f"{self.id},{self.ticket_id},{self.passenger_id},{self.passenger_name},{self.image},{self.flight_id},{self.origin_city}," + \
            f"{self.destination_city},{self.carousel}\n"
        
    # Return this record as a single line in a CSV file
    @staticmethod
    def csv_header():
        return "id,ticket_id,passenger_id,passenger_name,image,flight_id,origin_city," + \
            "destination_city,carousel\n"

