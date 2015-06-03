# LiteralSymbolSpacer.py
# clang-format gets confused by @[@{, fix this in some simple cases
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class LiteralSymbolSpacer(AbstractCustomFormatter):
    def format_lines(self, lines):

        lines_to_write = []
        for line in lines:
            to_append = [line]
            # Check if the line ends with @[@{, but with any number of spaces in between
            stripped_line = line.rstrip()
            if stripped_line.endswith("@{"):
                array_literal_precedes_dict = stripped_line[:-2].rstrip().endswith("@[")
                if array_literal_precedes_dict:
                    # Append two lines instead: everything up to the array literal, and the dict literal on its own
                    to_append = [stripped_line[:-2].rstrip() + "\n", "@{" + "\n"]

            lines_to_write += to_append

        return "".join(lines_to_write)

if __name__ == "__main__":
    LiteralSymbolSpacer().run()
