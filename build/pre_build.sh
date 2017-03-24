#!/bin/sh
if [ ! -d "/home/node/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi