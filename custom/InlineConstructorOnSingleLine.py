# InlineConstructorOnSingleLine.py
# clang-format is confused when an inline constructor is split onto separate lines.
# Puts both sides of the constructor's colon (:) on a single line.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class InlineConstructorOnSingleLine(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []
        preceding_line_ends_with_closing_paren = False
        for _, line in enumerate(lines):
            stripped_line = line.strip()

            if stripped_line.startswith(":") and preceding_line_ends_with_closing_paren:
                condensed_line = lines_to_write[-1].replace("\n", " ") + stripped_line
                lines_to_write[-1] = condensed_line
            else:
                lines_to_write.append(line)

            if stripped_line.endswith(")"):
                preceding_line_ends_with_closing_paren = True
            else:
                preceding_line_ends_with_closing_paren = False

        return "".join(lines_to_write)

if __name__ == "__main__":
    InlineConstructorOnSingleLine().run()
