FROM phusion/baseimage
MAINTAINER Graeme Mathieson <mathie@woss.name>

# Install system dependencies
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get dist-upgrade -qq -y
RUN apt-get install -qq -y ruby-switch ruby2.2 \
  build-essential ruby2.2-dev libpq-dev nodejs
RUN ruby-switch --set ruby2.2

# Clean up afterwards.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update Rubygems and install system-wide gems
RUN gem update --system --no-rdoc --no-ri
RUN gem update --no-rdoc --no-ri
RUN gem install --no-rdoc --no-ri bundler foreman

# Configure the environment for the app to run in.
ENV RAILS_ENV development
ENV PORT 5000

EXPOSE ${PORT}

# Setup runit to run the app
RUN mkdir -p /etc/service/wine_db_app
ADD config/deploy/app_runit_script.sh /etc/service/wine_db_app/run

# Install the app and its dependencies
COPY . /srv/wine_db
RUN cd /srv/wine_db && bundle install
