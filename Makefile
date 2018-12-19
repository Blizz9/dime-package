# This file is the command center of our app, these commands should handle most everything you would want to do.

# builds our app's docker container
build:
	docker build -f ./docker/Dockerfile -t dime-package .

# stops, builds, and runs our app's docker container; used for development testing
run: stop build
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name dime-package -p 8080:80 --net ecs dime-package:latest

# stops our app's docker container
stop:
	docker stop dime-package || true

# tails the logs of our running docker container
logs:
	docker logs -f dime-package

# drops, runs, and initializes our DB docker container
init-db: drop-db run-db
	cat ./database/buildscript.sql ./database/stagingscript.sql > ./database/final-buildscript.sql
	docker cp ./database/final-buildscript.sql dime-package-db:/var/lib/postgresql
	rm ./database/final-buildscript.sql
	docker exec dime-package-db psql -U postgres -d dime_package -f /var/lib/postgresql/final-buildscript.sql
	make stop-db

# stops then runs our DB docker container
run-db: stop-db
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name dime-package-db -p 5432:5432 --net ecs -v dime-package-db:/var/lib/postgresql/data -e POSTGRES_DB=dime_package -e POSTGRES_PASSWORD=dimepackagepassword postgres:latest
	docker cp ./docker/wait-for-it.sh dime-package-db:/usr/local/bin
	docker exec dime-package-db /usr/local/bin/wait-for-it.sh localhost:5432 -t 60 -- sleep 2s

# stops our DB docker container
stop-db:
	docker stop dime-package-db || true

# stops then drops our DB docker container volume (allows us to re-initialize a new DB volume)
drop-db: stop-db
	docker volume rm -f dime-package-db

# uses psql to give an interactive tool for interacting with our running DB docker container
inspect-db:
	docker exec -it dime-package-db psql -U postgres -d dime_package

# tails the logs of our running DB docker container
logs-db:
	docker logs -f dime-package-db
