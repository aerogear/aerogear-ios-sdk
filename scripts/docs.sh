#!/bin/bash
## Requires jazzy 
## https://github.com/realm/jazzy

rm -rf docs/api/core
rm -rf docs/api/auth

echo "Generating core documentation"
(cd modules/core && bundle exec jazzy --podspec agscore.podspec --output ../../docs/api/core)

echo "Generating auth documentation"
(cd modules/auth && bundle exec jazzy --podspec agsauth.podspec --output ../../docs/api/auth)