#!/bin/sh
cd /home/nodejs/app
meteor build --server-only --directory /home/nodejs/output

cd /home/nodejs/output/bundle/programs/server
npm install