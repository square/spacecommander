#!/usr/bin/env bash
# test.sh
# Checks that these scripts convert the unformatted file to the expected formatted result.
# Copyright 2015 Square, Inc

difference=$(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m | diff Testing\ Support/FormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
	echo "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m) Testing\ Support/FormattedExample.m \nto see why."
	exit $difference
fi

difference=$(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaPragmaUnformattedExample.m | diff Testing\ Support/ExemptViaPragmaFormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
	echo "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaPragmaUnformattedExample.m) Testing\ Support/ExemptViaPragmaFormattedExample.m \nto see why."
	exit $difference
fi

difference=$(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaCommentUnformattedExample.m | diff Testing\ Support/ExemptViaCommentFormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
  echo "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/ExemptViaCommentUnformattedExample.m) Testing\ Support/ExemptViaCommentFormattedExample.m \nto see why."
  exit $difference
fi

