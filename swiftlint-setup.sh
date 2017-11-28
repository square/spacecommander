#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SC_DIR="/Pods/SpaceCommander"
SWIFT_LINT_DIR="/Pods/SwiftLint/swiftlint"

SWIFTLINT="${DIR/$SC_DIR/$SWIFT_LINT_DIR}"
REPO_PATH="${DIR%$SC_DIR}"

echo ''
echo '## Setting Up Swiftlint ##'
echo '###############################'
echo "SwiftLint version $($SWIFTLINT version)"
if [ -e $REPO_PATH/.swiftlint.yml ]; then
  cp $REPO_PATH/.swiftlint.yml $DIR/.swiftlint.yml
else
  echo "No .swiftlint.yml rules file in repo. Swiftlint will be using the default rules!"
fi
echo '#### Done                 #####'
echo '###############################'



