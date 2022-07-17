SHA := $(shell git rev-parse --short=8 HEAD)
TAG := 0.1 

package-install:
	pipenv sync

genenv:
	python3 genenv.py
#-----------------------------------------------------------------------------
create-network:
	docker network create finmind_network

# mysql
mysql-up:
	 docker-compose -f mysql.yml up -d

mysql-down:
	 docker-compose -f mysql.yml down

build-image: genenv
	docker build -f Dockerfile -t finminddocker/finmind_visualization:${TAG} . --no-cache

push-image:
	docker push finminddocker/finmind_visualization:${TAG}

redash-up:
	docker-compose -f redash.yml up -d

redash-down:
	docker-compose -f redash.yml down

# redash
rabbitmq-up:
	docker-compose -f rabbitmq.yml up -d

rabbitmq-down:
	docker-compose -f rabbitmq.yml down

# api
finmind-up:
	docker-compose -f finmind.yml up -d

finmind-down:
	docker-compose -f finmind.yml down

run-celery:
	pipenv run celery -A redash.tasks.worker worker --loglevel=info --concurrency=1  --hostname=%h -Q finmind

# create table
create-mysql-table:
	docker-compose -f create_table.yml up

#--------------------------------------------------
direct-run:
	pipenv run uvicorn redash.main:app --workers 2 --host 0.0.0.0 --port 8888

format:
	black -l 80 redash tests