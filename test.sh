#!/usr/bin/env bash
# test.sh
# Checks that these scripts convert the unformatted file to the expected formatted result.
# Copyright 2015 Square, Inc

difference=$(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m | diff Testing\ Support/FormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
	echo "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/UnformattedExample.m) Testing\ Support/FormattedExample.m \nto see why."
	exit $difference
fi

difference=$(./format-objc-file-dry-run.sh Testing\ Support/ExemptUnformattedExample.m | diff Testing\ Support/ExemptFormattedExample.m - | wc -l)
if [ "$difference" -gt 0 ]; then
	echo "Tests fail. Run\n\t diff <(./format-objc-file-dry-run.sh Testing\ Support/ExemptUnformattedExample.m) Testing\ Support/ExemptFormattedExample.m \nto see why."
	exit $difference
fi

