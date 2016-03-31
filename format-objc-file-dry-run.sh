#!/usr/bin/env bash
# format-objc-file-dry-run.sh
# Outputs a formatted Objective-C file to stdout (doesn't alter the file).
# Copyright 2015 Square, Inc

export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -e ".clang-format" ]; then
	echo "Couldn't find .clang-format file, unable to format files. Please setup this repo by running the setup-repo.sh script from your repo's top level."
	echo "Also, formatting scripts should be run from the repo's top level dir."
	exit 1
fi

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

