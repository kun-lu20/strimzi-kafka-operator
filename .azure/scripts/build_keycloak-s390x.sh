#!/usr/bin/env bash

CUR_DIR = $(pwd)

cd $HOME
echo "Building and pushing keycloak and keycloak-init-container images\n"
git clone https://github.com/keycloak/keycloak-containers.git
cd keycloak-containers
git checkout 15.0.2
cd server
docker buildx build --platform linux/s390x --load --tag quay.io/keycloak/keycloak:15.0.2 .
cd ..
git checkout a03d3e8c54c3ad364d4ee912fca0298bc5a7099c
cd keycloak-init-container
docker buildx build --platform linux/s390x --load --tag quay.io/keycloak/keycloak-init-container:master .

cd $HOME
echo "Building and pushing keycloak-operator image\n"
git clone https://github.com/keycloak/keycloak-operator.git
cd keycloak-operator
git checkout 15.0.2
sed -i "s#registry.ci.openshift.org/openshift/release:golang-1.13#golang:1.13#g" Dockerfile
docker buildx build --platform linux/s390x --load --tag quay.io/keycloak/keycloak-operator:15.0.2 .

cd $HOME && rm -rf keycloak-containers keycloak-operator

cd $CUR_DIR
        