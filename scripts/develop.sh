## Development script used for verifying changes 
## before creating pull request

## Requirements

## brew install swiftlint
## brew install swiftformat

set -eo pipefail


## Correct files 

swiftlint autocorrect
swiftformat --disable trailingCommas,redundantSelf,unusedArguments --comments ignore --indent 4 . 

## Check if passing

swiftlint
