## Remove Cocoapods from the project
## Useful to cleanup project from dependency issues
## Requirement
## gem install cocoapods-deintegrate

cd ./tests
pod deintegrate
rm ./AeroGearSdkExample.xcworkspace

cd ..