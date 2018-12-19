build:
	docker build -t dime-package .

run: stop build
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name dime-package -p 8080:80 --net ecs dime-package:latest

stop:
	docker stop dime-package || true

logs:
	docker logs -f dime-package

init-db: drop-db run-db
	cat ./buildscript.sql ./stagingscript.sql > ./final-buildscript.sql
	docker cp ./final-buildscript.sql dime-package-db:/var/lib/postgresql
	rm ./final-buildscript.sql
	docker exec dime-package-db psql -U postgres -d dime_package -f /var/lib/postgresql/final-buildscript.sql
	make stop-db

run-db: stop-db
	docker network ls -f name=ecs | grep -q ecs || docker network create ecs
	docker run -d --rm --name dime-package-db -p 5432:5432 --net ecs -v dime-package-db:/var/lib/postgresql/data -e POSTGRES_DB=dime_package -e POSTGRES_PASSWORD=dimepackagepassword postgres:latest
	docker cp ./wait-for-it.sh dime-package-db:/usr/local/bin
	docker exec dime-package-db /usr/local/bin/wait-for-it.sh localhost:5432 -t 60 -- sleep 2s

stop-db:
	docker stop dime-package-db || true

drop-db: stop-db
	docker volume rm -f dime-package-db

inspect-db:
	docker exec -it dime-package-db psql -U postgres -d dime_package

logs-db:
	docker logs -f dime-package-db
