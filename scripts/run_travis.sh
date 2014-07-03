#!/bin/bash
set -ev

# setting up the database
RAILS_ENV=test bundle exec rake db:setup

# running tests
bundle exec rake

