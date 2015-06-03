# AbstractCustomFormatter.py
# Provides common functionality for custom formatters.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

import sys

class AbstractCustomFormatter(object):

    def run(self):
        if len(sys.argv) == 2:
            f = open(sys.argv[1], "r+b")
            formatted_lines = self.format_lines(f.readlines())
            f.close()

            f = open(sys.argv[1], "w+b")
            f.write(formatted_lines)
            f.close()
        else:
            formatted_lines = self.format_lines(sys.stdin.readlines())
            sys.stdout.write(formatted_lines)

    def format_lines(self, lines):
        return "".join(lines)

if __name__ == "__main__":
    AbstractCustomFormatter().run()
