# DoubleNewlineInserter.py
# Ensures double newlines are present in certain contexts (such as before a @interface block).
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class DoubleNewlineInserter(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []
        needs_double_newline_added = False
        comment_section = False
        for line in lines:
            stripped_line = line.strip()
            # Leave macros alone
            if stripped_line.startswith("#") or stripped_line.endswith("\\"):
                needs_double_newline_added = False
            elif stripped_line.startswith("@interface") or stripped_line.startswith("@implementation"):
                needs_double_newline_added = not comment_section

            if stripped_line.startswith("//") or stripped_line.strip().endswith("*/"):
                comment_section = True
            else:
                comment_section = False

            if needs_double_newline_added:
                lines_to_write.append("\n")
                lines_to_write.append("\n")
                needs_double_newline_added = False
            lines_to_write.append(line)
        return "".join(lines_to_write)

if __name__ == "__main__":
    DoubleNewlineInserter().run()
