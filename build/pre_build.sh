#!/bin/sh
if [ ! -d "/home/nodejs/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi

cd /home/nodejs/app && npm install