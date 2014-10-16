#!/bin/sh

cd $APP_PATH

bundle install --binstubs --jobs 2 --without development test