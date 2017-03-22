#!/bin/sh
meteor build --server-only --directory /home/nodejs/output

cd /home/nodejs/output
npm install