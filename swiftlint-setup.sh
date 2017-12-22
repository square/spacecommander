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
  echo "Error: No .swiftlint.yml rules file in repo."
fi

if [ -e $REPO_PATH/.swiftlint-unit-tests.yml ]; then
  cp $REPO_PATH/.swiftlint-unit-tests.yml $DIR/.swiftlint-unit-tests.yml
else
  echo "Error: No .swiftlint-unit-tests.yml rules file in repo."
fi
echo '#### Done                 #####'
echo '###############################'



