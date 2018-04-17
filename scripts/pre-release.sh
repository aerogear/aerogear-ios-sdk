#!/bin/bash
# Prepare for release
MODULES="core auth push"
SDK_VERSION=`cat VERSION|tr -d '[:space:]'`

echo "Update SDK Version to $SDK_VERSION"
sed -i.bak -E "s/DEVELOPMENT/${SDK_VERSION}/" ./modules/core/data/AgsMetadata.swift
for module in $MODULES
do
   sed -i.bak -E "s/\.version([ ]*)=([ ]*)(.*)/\.version\1=\2'$SDK_VERSION'/g" ./$module.podspec
done
echo "SDK version is updated to $SDK_VERSION"

echo "Push release tags"
git add -A && git commit -m "Release $SDK_VERSION"
git tag $SDK_VERSION
git push --tags