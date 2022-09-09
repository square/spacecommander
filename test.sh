#!/usr/bin/env bash
# test.sh
# Checks that these scripts convert the unformatted file to the expected formatted result.
# Copyright 2015 Square, Inc

set -o nounset
set -o errexit

function runTest() {
    formatted_example="Testing Support/$1FormattedExample$2"
    unformatted_example="Testing Support/$1UnformattedExample$2"
    formatted_in_place="Testing Support/$1FormattedInPlace$2"

    difference=$(./format-objc-file-dry-run.sh "$unformatted_example" | diff -q "$formatted_example" - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh '$unformatted_example') '$formatted_example' \nto see why."
        exit $difference
    fi

    # Test that the formatted version does not need further formatting
    difference=$(./format-objc-file-dry-run.sh "$formatted_example" | diff -q "$formatted_example" - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh '$formatted_example') '$formatted_example' \nto see why."
        exit $difference
    fi

    # Test that the in-place behavior does not differ from stdout
    cp "$unformatted_example" "$formatted_in_place"
    ./format-objc-file.sh "$formatted_in_place"
    difference=$(./format-objc-file-dry-run.sh "$unformatted_example" | diff -q "$formatted_in_place" - | wc -l)
    if [ "$difference" -gt 0 ]; then
        echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry.sh '$unformatted_example') '$formatted_in_place' \nto see why."
        echo "Then, remove the temporary file '$formatted_in_place'"
        exit $difference
    fi
    rm "$formatted_in_place"
}

runTest "" ".m"
runTest "ExemptViaPragma" ".m"
runTest "ExemptViaComment" ".m"
runTest "Unicode" ".m"
runTest "ImportOnlyHeader" ".h"

echo "Tests pass"
