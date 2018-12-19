build:
	docker build -t football .

run: stop build
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name football -p 8080:80 --net ecs football:latest

stop:
	docker stop football || true

logs:
	docker logs -f football

init-db: drop-db run-db
	cat ./buildscript.sql ./stagingscript.sql > ./final-buildscript.sql
	docker cp ./final-buildscript.sql football-db:/var/lib/postgresql
	rm ./final-buildscript.sql
	docker exec football-db psql -U postgres -d football -f /var/lib/postgresql/final-buildscript.sql
	make stop-db

run-db: stop-db
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name football-db -p 5432:5432 --net ecs -v football-db:/var/lib/postgresql/data -e POSTGRES_DB=football -e POSTGRES_PASSWORD=footballpassword postgres:latest
	docker cp ./wait-for-it.sh football-db:/usr/local/bin
	docker exec football-db /usr/local/bin/wait-for-it.sh localhost:5432 -t 60 -- sleep 2s

stop-db:
	docker stop football-db || true

drop-db: stop-db
	docker volume rm -f football-db

inspect-db:
	docker exec -it football-db psql -U postgres -d football

logs-db:
	docker logs -f football-db
