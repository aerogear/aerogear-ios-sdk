## Pods pre publish script 
## Scripts validates pod specifications before release.

set -eo pipefail

bundle exec pod spec lint