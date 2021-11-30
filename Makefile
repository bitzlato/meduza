.PHONY: all

pull_structure:
		ssh meduza@ex2.fr1.lgk.one "PGPASSWORD=${PRODUCTION_PGPASSWORD} pg_dump -U replication -h ${PRODUCTION_PGHOST} bitzlato --no-acl --no-owner -s -N meduza" > ./db/public.structure.sql

pull_data:
		ssh meduza@ex2.fr1.lgk.one "PGPASSWORD=${PRODUCTION_PGPASSWORD} pg_dump -U replication -h ${PRODUCTION_PGHOST} bitzlato --no-acl --no-owner -n meduza -a" > ./tmp/production.meduza.data.sql

db_pull: pull_structure pull_data reset_and_load_db

all: db_pull

reset_and_load_db:
		rake db:drop db:create RAILS_ENV=development 
		cat ./db/public.structure.sql | psql meduza_development
		cat ./tmp/production.meduza.data.sql | psql meduza_development
