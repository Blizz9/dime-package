# this imports the package we are using as a web server
from flask import Flask, Response, render_template

# this imports the package we are using for some minor OS stuff
import os

# this imports the package we are using as a DB access layer
import psycopg2

# this imports the package we are using as an HTTP request helper
import requests

from sportsreference.ncaaf.teams import Teams

# this reads all of the environment variables
host = os.environ['HOST']
port = os.environ['PORT']
dbConnectionString = os.environ['DB_CONNECTION_STRING']

# this defines our flask app, named 'webApp'
webApp = Flask(__name__)

# this function serves the '/updatetime' endpoint; it queries a free world clock web api for the current time and then
# stores what it retreived into the DB; it returns a 200 status code with a nice little message about the retreived
# time
@webApp.route("/updatetime")
def updateTime():
    # send an HTTP GET request to the free web api and then extract the time from the response
    timeAPIResponse = requests.get("http://worldclockapi.com/api/json/est/now")
    timeString = timeAPIResponse.json()['currentDateTime']

    # create a connection to the DB
    dbConnection = psycopg2.connect(dbConnectionString)
    dbCursor = dbConnection.cursor()

    # execute an UPDATE SQL statement on the world_time table in the DB, injecting the proper time string
    dbCursor.execute("""UPDATE world_time SET time = %s WHERE id = 1;""", (timeString,))
    # commit the above query to the DB
    dbConnection.commit()

    # clean up the connection to the DB
    dbCursor.close()
    dbConnection.close()

    # give an HTTP response with a nice message and the retreived and stored time string
    return Response(
        "Web API queried successfully and DB record updated successfully: " + timeString,
        status=200,
    )

# this function serves the '/gettime' endpoint; it queries the DB for the current stored time and returns a 200 status
# code with a nice little message about the retreived time
@webApp.route("/gettime")
def getTime():
    # create a connection to the DB
    dbConnection = psycopg2.connect(dbConnectionString)
    dbCursor = dbConnection.cursor()

    # execute a SELECT SQL statement on the world_time table in the DB retreiving the current time string
    dbCursor.execute("SELECT time FROM world_time WHERE id = 1")
    row = dbCursor.fetchone()

    # clean up the connection to the DB
    dbCursor.close()
    dbConnection.close()

    # give an HTTP response with a nice message and the retreived time string
    return Response(
        "DB queried successfully - Time: " + row[0],
        status=200,
    )

@webApp.route("/updateteams")
def updateTeams():
    dbConnection = psycopg2.connect(dbConnectionString)
    dbCursor = dbConnection.cursor()

    dbCursor.execute("""TRUNCATE TABLE teams;""")

    teams = Teams(2018)
    for team in teams:
        dbCursor.execute("""INSERT INTO teams VALUES(DEFAULT, %s, %s, %s);""", (team._year, team.name, team.conference,))
    dbConnection.commit()

    dbCursor.close()
    dbConnection.close()

    return Response(
        "All teams updated to database successfully",
        status=200,
    )

# this function serves the '/' endpoint; it serves index.html from the ./templates directory with a few values injected
# into the template
@webApp.route('/')
def indexRoute():
    title = "Project Dime Package"
    # render the template with some injected values
    return render_template('index.html', title=title)

# run our webApp server on the specified host and port
if __name__ == '__main__':
    webApp.run(host=host, port=port)
