#!/bin/bash
# Publish service modules
MODULES="AGSAuth AGSPush"
SWIFT_VERSION=4.1

echo "Lint pods specifications"
for module in $MODULES
do
  echo "Check pod $module"
  bundle exec pod lib lint ${module}.podspec  --swift-version=${SWIFT_VERSION} --no-subspecs --no-clean --allow-warnings --verbose
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
  bundle exec pod trunk push ${module}.podspec --skip-import-validation --swift-version=${SWIFT_VERSION} --allow-warnings --verbose
  echo "Pod $module released"
done
echo "Done."