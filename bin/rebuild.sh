#!/bin/bash

docker rm $(docker ps -q)
docker rmi $(docker images -q)
