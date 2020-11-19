#!/usr/bin/env bash
# test.sh
# Checks that these scripts convert the unformatted file to the expected formatted result.
# Copyright 2015 Square, Inc

set -o nounset
set -o errexit

function runTest() {
    difference=$(./format-objc-file-dry-run.sh Testing\ Support/$1UnformattedExample.m | diff -q Testing\ Support/$1FormattedExample.m - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh 'Testing Support/$1UnformattedExample.m') 'Testing Support/$1FormattedExample.m' \nto see why."
        exit $difference
    fi

    # Test that the formatted version does not need further formatting
    difference=$(./format-objc-file-dry-run.sh Testing\ Support/$1FormattedExample.m | diff -q Testing\ Support/$1FormattedExample.m - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh 'Testing Support/$1FormattedExample.m') 'Testing Support/$1FormattedExample.m' \nto see why."
        exit $difference
    fi

    # Test that the in-place behavior does not differ from stdout
    cp "Testing Support/$1UnformattedExample.m" "Testing Support/$1FormattedInPlace.m"
    ./format-objc-file.sh "Testing Support/$1FormattedInPlace.m"
    difference=$(./format-objc-file-dry-run.sh Testing\ Support/$1UnformattedExample.m | diff -q Testing\ Support/$1FormattedInPlace.m - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry.sh Testing\ Support/$1UnformattedExample.m) Testing\ Support/$1FormattedInPlace.m \nto see why."
        echo "Then, remove the temporary file Testing\ Support/$1FormattedInPlace.m"
        exit $difference
    fi
    rm "Testing Support/$1FormattedInPlace.m"
}

runTest ""
runTest "ExemptViaPragma"
runTest "ExemptViaComment"
runTest "Unicode"

echo "Tests pass"
