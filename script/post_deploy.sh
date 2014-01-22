#!/usr/bin/env sh

bundle exec rake db:migrate
bundle exec rake assets:build
