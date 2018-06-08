#!/bin/bash
# Prepare for release
GIT_PUSH="${GIT_PUSH:-1}"
SDK_VERSION=`cat VERSION|tr -d '[:space:]'`

META_SDK_SEARCH='(sdkVersion[[:space:]]=[[:space:]])(\")([0-9]+\.[0-9]+\.[0-9]+(-.+)*)(\")'
META_SDK_REPLACE="\1\2${SDK_VERSION}\4\5"

echo "Update SDK Version to $SDK_VERSION"
sed -i.bak -E "s/${META_SDK_SEARCH}/${META_SDK_REPLACE}/" ./modules/core/data/AgsMetadata.swift
sed -i.bak -E "s/\.version([ ]*)=([ ]*)(.*)/\.version\1=\2'$SDK_VERSION'/g" ./*.podspec

echo "SDK version is updated to $SDK_VERSION"
