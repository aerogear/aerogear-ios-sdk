#!/bin/bash
SDK_VERSION=`cat VERSION|tr -d '[:space:]'`
modules=($(ls | grep -E .podspec$ | awk -F '.' '{ print $1 }'))

# explicit declaration that this script needs a $TAG variable passed in e.g TAG=1.2.3 ./script.sh
TAG=$TAG
TAG_SYNTAX='[0-9]+\.[0-9]+\.[0-9]+(-.+)*$'

# validate tag has format x.y.z
if [[ "$(echo $TAG | grep -E $TAG_SYNTAX)" == "" ]]; then
  echo "tag $TAG is invalid. Must be in the format x.y.z or x.y.z-SOME_TEXT"
  exit 1
fi

# validate that TAG == SDK_VERSION
if [[ $TAG != $SDK_VERSION ]]; then
  echo "tag $TAG is not the same as sdk version $SDK_VERSION"
  exit 1
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
     exit 1
   fi
done

echo "TAG and SDK_VERSION are valid"

