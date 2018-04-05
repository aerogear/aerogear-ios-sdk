#!/bin/bash
# Push the AGSCore pod
# Scripts validates pod specifications before release
set -eo pipefail

echo "Lint pod core"
(cd ./modules/core && bundle exec pod lib lint)
if [ $? -eq 0 ]; then
  echo "Pod core is ready for release"
else
  echo "Pod core is not ready for release"
  exit 1
fi

echo "Release pod core"
(cd ./modules/core && bundle exec pod trunk push)
echo "Pod core released"