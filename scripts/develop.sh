## Development script used for verifying changes 
## before creating pull request

## Requirements

## brew install swiftlint
## brew install swiftformat

set -eo pipefail

swiftlint autocorrect
swiftformat --disable trailingCommas,redundantSelf,unusedArguments --comments ignore --indent 4 . 