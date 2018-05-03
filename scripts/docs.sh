#!/bin/bash
## Requires jazzy 
## https://github.com/realm/jazzy

rm -rf docs/api/core
rm -rf docs/api/auth

echo "Generating core documentation"
bundle exec jazzy --podspec ./AGSCore.podspec --output ./docs/api/core

echo "Generating auth documentation"
## Remove core dependency
sed -i.bck "s/s.dependency 'AGSCore'/ /g" ./AGSAuth.podspec
bundle exec jazzy --podspec ./AGSAuth.podspec --output ./docs/api/auth

echo "Generating push documentation"
## Remove core dependency
sed -i.bck "s/s.dependency 'AGSCore'/ /g" ./AGSPush.podspec
bundle exec jazzy --podspec ./AGSPush.podspec --output ./docs/api/push
