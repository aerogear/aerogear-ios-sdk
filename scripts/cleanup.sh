## Remove Cocoapods from the project
## Useful to cleanup project from dependency issues
## Requirement
## gem install cocoapods-deintegrate

cd ./example
pod deintegrate
rm ./AeroGearSdkExample.xcworkspace

cd ..