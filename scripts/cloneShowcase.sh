echo "Clonning showcase application"

git clone git@github.com:aerogear/ios-showcase-template.git showcase
(cd showcase && && pod setup && LOCAL_DIR=../ pod install)
