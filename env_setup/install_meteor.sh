#!/bin/sh
apt-get update && apt-get install build-essential g++ python make -y

curl https://install.meteor.com | sh
