# This represents a single flight

class Flight:
    def __init__(self, flight_id, origin_city, destination_city, departure_time, departure_gate, carousel):
        self.flight_id = flight_id
        self.origin_city = origin_city
        self.destination_city = destination_city
        self.departure_time = departure_time
        self.departure_gate = departure_gate
        self.carousel = carousel

    def print(self):
        print(self.flight_id + " - From: " + self.origin_city + "  To: " + self.destination_city + 
            " departing at " + self.departure_time + " from gate " + self.departure_gate + " carousel: " + self.carousel)
