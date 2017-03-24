#!/bin/sh
if [ ! -d "/home/nodejs/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi

echo change owner of "/home/nodejs/app" as nodejs:nodejs
chown -Rh nodejs:nodejs /home/nodejs/app