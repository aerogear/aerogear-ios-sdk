set -eo pipefail

## For running on local machine 
## gem install xcpretty

test_iOS() {
  xcodebuild \
    -workspace example/AeroGearSdkExample.xcworkspace \
    -scheme AeroGearSdkExample \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 7' \
    build \
    test \
    ONLY_ACTIVE_ARCH=YES \
    CODE_SIGNING_REQUIRED=NO \
    | xcpretty
}

test_iOS; RESULT=$?

if [ $RESULT != 0 ]; then exit $RESULT; fi