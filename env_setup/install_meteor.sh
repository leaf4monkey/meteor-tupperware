#!/bin/sh
apt-get update && apt-get install build-essential g++ python -y

curl https://install.meteor.com | sh
