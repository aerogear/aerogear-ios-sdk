#!/bin/bash

## Generate new AeroGear services SDK
# Usage: script.sh [-n=name|--name=val]
# Description: Creates new SDK 

set -eo pipefail

# Defaults #
SDK_NAME="AGExampleService"

# Parse Parameters #
for ARG in $*; do
  case $ARG in
    -n=*|--name=*)
      SDK_NAME=${ARG#*=} 
      ;;
    *)
      echo "Unknown Argument $ARG. Usage: script.sh [-n=SDKName|--name=SDKName]" ;;
  esac
done

SDK_DESCRIPTION="AeroGear Services $SDK_NAME"

## Rexport values
export SDK_NAME=$SDK_NAME
export SDK_DESCRIPTION=$SDK_DESCRIPTION

echo "Create folder for SDK"
mkdir -p ./modules/$SDK_NAME 

echo "Create documentation folder and file"
mkdir -p ./docs/$SDK_NAME 

echo "Create test folder"
mkdir -p ./example/AeroGearSdkExampleTests/$SDK_NAME

echo "Copy and process module templates"
envsubst < ./template/service.podspec > ./modules/$SDK_NAME/${SDK_NAME}.podspec
envsubst < ./template/Service.swift_template > ./modules/$SDK_NAME/${SDK_NAME}.swift 

echo "Copy and process docs and unit tests"
envsubst < ./template/README.adoc > ./docs/$SDK_NAME/README.adoc
envsubst < ./template/ServiceTests.swift_template > ./example/AeroGearSdkExampleTests/$SDK_NAME/${SDK_NAME}Tests.swift
 
echo "SDK generated successfully"
