#!/bin/bash

sudo docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /home/docker/registry/:/var/lib/registry/docker/registry \
  -v /home/docker/registry-config.yml:/etc/docker/registry/config.yml \
  registry:latest
