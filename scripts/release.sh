#!/bin/bash
# Push the AGSCore pod
# Scripts validates pod specifications before release
MODULES="AGSAuth AGSPush"
set -eo pipefail

SWIFT_VERSION=4.1

echo "Lint library locally before attepting to fetch remote sources "
pod lib lint AGSCore.podspec  --swift-version=${SWIFT_VERSION} --no-subspecs --allow-warnings
if [ $? -eq 0 ]; then
  echo "Pod core is ready for release"
else
  echo "Pod core is not ready for release"
  exit 1
fi

echo "Release pod core"
pod trunk push AGSCore.podspec --skip-import-validation --swift-version=${SWIFT_VERSION} --allow-warnings
echo "Pod core released"

echo "releasing modules $MODULES"
echo "Lint pods specifications"
for module in $MODULES
do
  echo "Check pod $module"
  pod lib lint ${module}.podspec  --swift-version=${SWIFT_VERSION} --no-subspecs --allow-warnings
  if [ $? -eq 0 ]; then
    echo "Pod $module is ready for release"
  else
    echo "Pod $module is not ready for release"
    exit 1
  fi
done

echo "Release pods"
for module in $MODULES
do
  echo "Release pod $module"
  pod trunk push ${module}.podspec --skip-import-validation --swift-version=${SWIFT_VERSION} --allow-warnings
  echo "Pod $module released"
done
echo "Done."