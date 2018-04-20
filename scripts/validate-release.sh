#!/bin/bash
MODULES="core auth push"
SDK_VERSION=`cat VERSION|tr -d '[:space:]'`

# explicit declaration that this script needs a $TAG variable passed in e.g TAG=1.2.3 ./script.sh
TAG=$TAG
TAG_SYNTAX='[[:digit:]].[[:digit:]].[[:digit:]]'

# validate tag has format x.y.z
if [[ ! $TAG =~ $TAG_SYNTAX ]]; then
  echo "tag $TAG does not have correct syntax x.y.z. exiting..."
  exit 1
fi

# validate that TAG == SDK_VERSION
if [[ $TAG != $SDK_VERSION ]]; then
  echo "tag $TAG is not the same as sdk version $SDK_VERSION"
  exit
fi

echo "TAG and SDK_VERSION are valid"

