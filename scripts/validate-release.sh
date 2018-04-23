#!/bin/bash

SDK_VERSION=`cat VERSION|tr -d '[:space:]'`
declare -a modules=("AGSCore" "AGSAuth" "AGSPush")

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

## check each podspec and ensure version numbers match
for i in "${modules[@]}"
do
   specname="$i.podspec"
   spec=`cat $specname`
   
   match="s.version[[:space:]]*=[[:space:]]'$SDK_VERSION'"
   
   if [[ $spec =~ $match ]]; then
     echo "$specname valid"
   else
     echo "version number mismatch in $specname"
     exit 1;
   fi
done

echo "TAG and SDK_VERSION are valid"

