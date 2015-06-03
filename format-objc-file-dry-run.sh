#!/usr/bin/env bash
# format-objc-file-dry-run.sh
# Outputs a formatted Objective-C file to stdout (doesn't alter the file).
# Copyright 2015 Square, Inc

export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# "#pragma Formatter Exempt" on the first line means don't format this file 
line="$(head -1 "$1" | xargs)" # (read the first line and trim it)
if [ "$line" == "#pragma Formatter Exempt" ]; then
	cat "$1" && exit 0
fi

cat "$1" | \
python "$DIR"/custom/LiteralSymbolSpacer.py | \
python "$DIR"/custom/InlineConstructorOnSingleLine.py | \
python "$DIR"/custom/MacroSemicolonAppender.py | \
python "$DIR"/custom/DoubleNewlineInserter.py | \
"$DIR"/bin/clang-format-3.7 -style=file | \
python "$DIR"/custom/NewLineAtEndOfFileInserter.py

