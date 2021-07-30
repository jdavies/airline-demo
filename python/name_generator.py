# name_generator.py
#
# Purpose: Utility file to generate random names
# Author: Jeff Davies (mailto:jeff.davies@datastax.com)
#
import random

# Seed the random number generator with the current time

class NameGenerator:
    # Class constructor
    def __init__(self):
        random.seed()

    # An array of first names
    first_name_list = [
        "Aaron", "Abe", "Able", "Abraham", "Allan", "Allen",
        "Barnaby", "Barnabut", "Barney", "Barry", "Bart", "Bartholemew", "Bat", "Beoit", "Bhavana", "Bill", "Billy", "Bob", 
        "Brad", "Bret", "Brandon", "Brett", "Bryce", "Bubba", "Buford", "Byron",
        "Candy", "Carl", "Carlos", "Carey", "Carol", "Cary", "Cassandra", "Cassy", "Cassie", "Cecil", "Cedric", 
        "Charity", "Charles", "Charlene", "Charlie", "Chastity", "Cheryl", "Chralie", "Charles", "Charlene", "Chip", "Chuck",
        "Cindy", "Charol", "Chuck", "Claude", "Claudette", "Clint", "Clinton", "Cyril", "Cyrus",
        "Dabny", "Dan", "Daniel", "Daphne", "Darren", "Darrel", "Darrol", "Dave", "David", "Don", "Donald", "Duke",
        "Ezekiel", "Ezra",
        "Faith", "Fatima", "Flora", "Florence", "Flo",
        "Gautam", "Gene", "Gerry", "Gordon",
        "Hank", "Hannah", "Harold", "Harry", "Helen", "Hope", "Hyman",
        "Iasaac",
        "Jack", "Jacob", "Jake", "Jane", "James", "Jarold", "Jason", "Jean", "Jeff", "Jeffery", "Jefferson", "Jeffrey", "Jeffry", "Jen", "Jennifer", 
        "Jeremy", "Jerry", "Jim", "Jimmy", 
        "John", "Jocelyn", "John", "Johnny", "Johnathon", "Jonathon", "Jules", 
        "Karen", "Karey", "Karrie",
        "Lara", "Latha", "Laura", "Lillith", "Lilly", "Lisa", "Lois", "Lou", "Louis", "Lucille", "Lucy", "Luke",
        "Maggie", "Mags", "Margaret", "Maury", "Mic", "Mickey", "Michael", "Mike", "Mohammd", "Mohammad", "Moe",
        "Nitin",
        "Paul", "Paula",
        "Rajeev", "Ram", "Ric", "Rick", "Rich", "Richard", "Ricky", 
        "Rod", "Ron", "Ronald", "Ronie", "Ronny", "Rose", "Rosemary", "Rosemarie", "Ruby",
        "Sandy", "Sharad", "Sheryl", "Shrin", "Srini", 
        "Val", "Valierie", "Valeria", "Venkat", "Vern", "Vernon", "Vickie", "Vick", "Victor", "Victoria", "Vikram",
        "Zeke"
    ]

    last_name_list = [
        "Abel", "Acharya", "Acton", "Agarwal", "Ahuja", "Amiri", "Anand", "Anderson", "Anthony", "Arya", "Asimov",
        "Babu", "Baker", "", "Barn", "Bernhard", "Bernhardt", "Burns", "Buell",
        "Cane", "Caine", "Carson", "Carol", "Charoll", "Carsten", "Coen", "Colby", "Crane", "Cronkite",
        "Davidson", "Davies", "Davis", "Donaldson", "Driver",
        "Flowers", "Flores",
        "Gable", "Garrison", "Good", "Goode", "Golightly", "Goodman", "Gupta",
        "Jacks", "Jackson", "Jain", "James", "Jefferson", "Joice", "Joiner", "Jules",
        "Kane", "Keeney", "Khatri", "Krane", "Knight", "Knightly",
        "Laghari", "Lee", "Leigh", "Lynn", "Lightfoot", 
        "Manson", "Mason", "Masterson", "Masters", "MacDonald", "McDonald", "McGregor", "McMasters", "McPhearson", "Mudd", "Murrow", 
        "Nancy", "Navuluri", "Night", "Nightingale", "Nine", "Nipur", "No",
        "Patel", "Patterson", "Paul", "Petersons", "Peters", "Pitt", "Pitts", "Pond", "Pound", "Poundstone", "Povich", "Preston",
        "Ralston", "Rand", "Rao", "Rasta", "Raston", "Reddy", "Roden", "Roddenbery", "Ruby", 
        "Sales", "Simms", "Spimpson", "Smith", "Sam", "Sams", "Simmons",
        "Vannah", "Vale", "Vail",
        "Zyten"
    ]

    def random_first_name(self):
        first_index = random.randrange(0,len(self.first_name_list), 1)
        return self.first_name_list[first_index]

    def random_last_name(self):
        index = random.randrange(0,len(self.last_name_list), 1)
        return self.last_name_list[index]

    def random_name(self):
        return self.random_first_name() + " " + self.random_last_name()

