## Pods pre publish script 
## Scripts validates pod specifications before release
## Requires: gem install cocoapods-release, gem install cocoapods-appledoc
## 
pod release
set -eo pipefail

# Parse Parameters #
for ARG in $*; do
  case $ARG in
    -v=*|--version=*)
      SDK_VERSION=${ARG#*=} 
      ;;
    *)
      echo "Unknown Argument $ARG. Usage: script.sh [-n=SDKName|--name=SDKName]" ;;
  esac
done

echo "Replace version"
sed -i 's/DEVELOPMENT/'${SDK_VERSION}'/g' ./modules/core/AgsMetadata.swift

echo "Lint pods specifications"
bundle exec pod spec lint

echo "Release with tags"
echo "Manual step! Execute 'bundle exec pod release'"