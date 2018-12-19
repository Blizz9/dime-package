from flask import Flask, Response, render_template
import psycopg2
import requests

app = Flask(__name__)

@app.route("/updatetime")
def updateTime():
    timeAPIResponse = requests.get("http://worldclockapi.com/api/json/est/now")
    timeString = timeAPIResponse.json()['currentDateTime']

    dbConnection = psycopg2.connect(host="dime-package-db", database="dime_package", user="postgres", password="dimepackagepassword")
    dbCursor = dbConnection.cursor()

    dbCursor.execute("""UPDATE world_time SET time = %s WHERE id = 1;""", (timeString,))
    dbConnection.commit()

    dbCursor.close()
    dbConnection.close()

    return Response(
        "Web API queried successfully and DB record updated successfully: " + timeString,
        status=200,        
    )

@app.route("/gettime")
def getTime():
    dbConnection = psycopg2.connect(host="dime-package-db", database="dime_package", user="postgres", password="dimepackagepassword")
    dbCursor = dbConnection.cursor()

    dbCursor.execute("SELECT time FROM world_time WHERE id = 1")
    row = dbCursor.fetchone()

    print(row[0])

    dbCursor.close()
    dbConnection.close()

    return Response(
        "DB queried successfully - Time: " + row[0],
        status=200,        
    )

@app.route('/')
def indexRoute():
    author = "Me"
    name = "You"
    return render_template('index.html', author=author, name=name)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='80')
