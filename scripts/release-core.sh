#!/bin/bash
# Push the AGSCore pod
# Scripts validates pod specifications before release
set -eo pipefail

SWIFT_VERSION=4.1


echo "Lint library locally before attepting to fetch remote sources "
bundle exec pod lib lint AGSCore.podspec  --swift-version=${SWIFT_VERSION} --no-subspecs --no-clean --allow-warnings --verbose
if [ $? -eq 0 ]; then
  echo "Pod core is ready for release"
else
  echo "Pod core is not ready for release"
  exit 1
fi

echo "Release pod core"
bundle exec pod trunk push AGSCore.podspec --skip-import-validation --swift-version=${SWIFT_VERSION} --allow-warnings --verbose
echo "Pod core released"