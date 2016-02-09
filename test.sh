#!/usr/bin/env bash
# test.sh
# Checks that these scripts convert the unformatted file to the expected formatted result.
# Copyright 2015 Square, Inc

# Test that the in-place behavior does not differ from stdout
cp Testing\ Support/UnformattedExample.m Testing\ Support/FormattedInPlace.m
./format-objc-file.sh Testing\ Support/FormattedInPlace.m
difference=$(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m | diff Testing\ Support/FormattedInPlace.m - | wc -l)
if [ "$difference" -gt 0 ]; then
    echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m) Testing\ Support/FormattedInPlace.m \nto see why."
    echo "Then, remove the temporary file Testing\ Support/FormattedInPlace.m"
    exit $difference
fi
rm Testing\ Support/FormattedInPlace.m

difference=$(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m | diff Testing\ Support/FormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
    echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m) Testing\ Support/FormattedExample.m \nto see why."
    exit $difference
fi

difference=$(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaPragmaUnformattedExample.m | diff Testing\ Support/ExemptViaPragmaFormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
    echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaPragmaUnformattedExample.m) Testing\ Support/ExemptViaPragmaFormattedExample.m \nto see why."
    exit $difference
fi

difference=$(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaCommentUnformattedExample.m | diff Testing\ Support/ExemptViaCommentFormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
  echo -e "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaCommentUnformattedExample.m) Testing\ Support/ExemptViaCommentFormattedExample.m \nto see why."
  exit $difference
fi

echo "Tests pass"

