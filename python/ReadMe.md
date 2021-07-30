# ReadMe.md

These python scripts are used to generate and clean data from the demo tables.

## Create Your credentials.py file

The generate.py file will look for a credentials.py file. Your credentials.py file should be in the following format:

```sh
client_id="<your client id>"
client_secret="<your client secret>"
```

## Creating the CSV Files

Right now, the only script that is really used is the generate.py

```sh
python generate.py
```

That will create the CSV files that contain all of the data needed for the database. Tken togther, they create a fully populated database with 4.1M ticket records for 41,000 flights.

All generated files will appear in the ```database/``` folder and any previous versions of those files will be deleted. Please refer to the [User's Guide](../UsersGuide.md) for how to crate your datbase with these files.
