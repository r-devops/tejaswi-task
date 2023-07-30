#! /bin/bash
rm -rf docker-file
git clone https://github.com/searce-thejaswini/docker-file
cd docker-file
docker build -t local/jenkins .
docker run --name jenkins -p 8080:8080 -d local/jenkins

