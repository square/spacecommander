#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SC_DIR="/Pods/SpaceCommander"
SWIFT_LINT_DIR="/Pods/SwiftLint/swiftlint"

SWIFTLINT="${DIR/$SC_DIR/$SWIFT_LINT_DIR}"
REPO_PATH="${DIR%$SC_DIR}"

$SWIFTLINT autocorrect --path $REPO_PATH --config .swiftlint.yml
$SWIFTLINT autocorrect --path $REPO_PATH --config .swiftlint-unit-tests.yml
