#!/bin/sh

export DATABASE_URL="postgresql://postgres@${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}/wine_db?pool=5"

cd /srv/wine_db

bundle install
bundle exec rake db:create
bundle exec rake db:migrate

foreman start
