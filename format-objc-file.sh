#!/usr/bin/env bash
# format-objc-file.sh
# Formats an Objective-C file, replacing it without a backup.
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
[ "$line" == "#pragma Formatter Exempt" -o "$line" == "// MARK: Formatter Exempt" ] && exit 0

# Use stdout as a workaround to an issue described below.
cat "$1" | \
# clang-format gets confused by @[@{, fix this in some simple cases
python "$DIR"/custom/LiteralSymbolSpacer.py | \
# Fix an edge case with array / dictionary literals that confuses clang-format
python "$DIR"/custom/InlineConstructorOnSingleLine.py | \
# Add a semicolon at the end of simple macros
python "$DIR"/custom/MacroSemicolonAppender.py | \
# Add an extra newline before @implementation and @interface
python "$DIR"/custom/DoubleNewlineInserter.py | \
# Run clang-format
"$DIR"/bin/clang-format-3.8-custom -style=file | \
# Fix an issue with clang-format getting confused by categories with generic expressions.
python "$DIR"/custom/GenericCategoryLinebreakIndentation.py | \
# Fix an issue with clang-format breaking up a lone parameter onto a newline after a block literal argument.
python "$DIR"/custom/ParameterAfterBlockNewline.py | \
# Fix an issue with clang-format inserting spaces in a preprocessor macro.
python "$DIR"/custom/HasIncludeSpaceRemover.py | \
# Add a newline at the end of the file
python "$DIR"/custom/NewLineAtEndOfFileInserter.py > "$1"
# FIXME: redirecting stdout to the file is up to 2x slower. It's necessary because of a clang-format bug.
# clang-format has an -i (inplace) flag which somehow breaks "SortInclude: true".
# Use "-i" again when this is no longer an issue for clang-format.

