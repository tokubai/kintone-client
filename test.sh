#!/bin/sh
function run_test {
  bundle install
  bundle exec rake
}

FARADAY_VERSION=0.8.9 run_test
FARADAY_VERSION=0.9.1 run_test
