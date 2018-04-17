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

echo "Lint library locally before attepting to fetch remote sources "
pod lib lint AGSCore.podspec  --swift-version=4.1 --no-subspecs --no-clean --allow-warnings --verbose

echo "Release pod core"
bundle exec pod trunk push AGSCore.podspec --skip-import-validation --swift-version=4.1 --allow-warnings --verbose
echo "Pod core released"