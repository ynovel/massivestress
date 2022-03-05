#!/bin/sh
snap install docker
until docker version > /dev/null 2>&1
do
  echo "awaiting docker daemon starts..."
  sleep 1
done
