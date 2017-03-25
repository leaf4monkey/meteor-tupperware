#!/bin/sh
cd /home/node/app
meteor build --server-only --directory /home/node/output $ADDITIONAL_FLAGS
