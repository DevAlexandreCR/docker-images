#!/bin/bash

PHP_IMAGE=$1
PHP_VERSION=$2
PUSH=$3
PUSH_TAG=$4

if [ -z "$PHP_IMAGE" ]; then
  echo "Provide an image to build, options are:"
  echo -e "\tphp-vapor"
  echo -e "\tphp-image"
  echo -e "Example\n\t./build.sh php-vapor php74 -p"
  exit
fi

if [ -z "$PHP_VERSION" ]; then
  echo "Provide a version to build, options are:"
  echo -e "\tphp74"
  echo -e "\tphp80"
  echo -e "\tphp80-pipeline"
  echo -e "\tphp81"
  echo -e "\tphp81-pipeline"
  echo -e "Example\n\t./build.sh php-vapor php74 -p"
  exit
fi

if [ -z "$PUSH_TAG" ]; then
  PUSH_TAG=$PHP_VERSION
fi

echo "Running build for $PHP_VERSION"
docker build -t ${PHP_IMAGE}-${PHP_VERSION}:latest ${PHP_IMAGE}/${PHP_VERSION}

if [ $? -ne 0 ]; then
  echo "We have error - build failed!"
  exit $?
fi

echo "Tagging the version as latest"
docker tag ${PHP_IMAGE}-${PHP_VERSION}:latest placetopay/${PHP_IMAGE}:${PUSH_TAG}

if [[ ! -z "$PUSH" ]]; then
  echo "Pushing image to DockerHub"
  docker push placetopay/${PHP_IMAGE}:${PUSH_TAG}
fi
