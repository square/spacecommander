# NewLineAtEndOfFileInserter.py
# Ensures there's a newline at the end of each file.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class NewLineAtEndOfFileInserter(AbstractCustomFormatter):
    def format_lines(self, lines):
        if len(lines) > 0 and not lines[-1].endswith("\n"):
            lines[-1] += "\n"
        return "".join(lines)

if __name__ == "__main__":
    NewLineAtEndOfFileInserter().run()
