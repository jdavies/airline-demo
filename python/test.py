from flight import Flight
from flight_generator import FlightGenerator

def test():
    print("In the test!")

print ("Hello")
test()
x = "%04d" % 1
print (x)
f = Flight("one", "two", "three", "four", "five")
f.print()

print("Testing the flight generator...")
flight_gen = FlightGenerator()
for x in range(10):
    f = flight_gen.random_flight()
    f.print()

one = "Harry"
two = "Houdini"
test2 = f"hello '{one}', '{two}'"
print(test2)
cql = f'insert into flight(id, origin_city, destination_city, departure_time, departure_gate) ' + \
    f'values(\'{f.flight_id}\', \'{f.origin_city}\', \'{f.destination_city}\', \'{f.departure_time}\', \'{f.departure_gate}\');'
print(cql) 