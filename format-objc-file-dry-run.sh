#!/usr/bin/env bash
# format-objc-file-dry-run.sh
# Outputs a formatted Objective-C file to stdout (doesn't alter the file).
# Copyright 2015 Square, Inc

export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# "#pragma Formatter Exempt" or "// MARK: Formatter Exempt" means don't format this file.
# Read the first line and trim it.
line="$(head -1 "$1" | xargs)" 
if [ "$line" == "#pragma Formatter Exempt" -o "$line" == "// MARK: Formatter Exempt" ]; then
  cat "$1" && exit 0
fi

cat "$1" | \
python "$DIR"/custom/LiteralSymbolSpacer.py | \
python "$DIR"/custom/InlineConstructorOnSingleLine.py | \
python "$DIR"/custom/MacroSemicolonAppender.py | \
python "$DIR"/custom/DoubleNewlineInserter.py | \
"$DIR"/bin/clang-format-3.8-custom -style=file | \
python "$DIR"/custom/GenericCategoryLinebreakIndentation.py | \
python "$DIR"/custom/ParameterAfterBlockNewline.py | \
python "$DIR"/custom/HasIncludeSpaceRemover.py | \
python "$DIR"/custom/NewLineAtEndOfFileInserter.py

