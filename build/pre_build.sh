#!/bin/sh
if [ ! -d "/home/nodejs/app/.meteor" ]; then
  echo "This doesn't look like a Meteor project. Meteor-builder is exiting..."
  exit 1
fi

cd /home/nodejs/app && npm install

chown -R nodejs:nodejs /home/nodejs/output
chown -R nodejs:nodejs /home/nodejs/app

sudo chown -Rh nodejs /home/nodejs/app/.meteor/local