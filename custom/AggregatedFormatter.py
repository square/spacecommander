
from AbstractCustomFormatter import AbstractCustomFormatter
from io import StringIO

class AggregatedFormatter(AbstractCustomFormatter):

    def __init__(self, formatters):
        self.formatters = formatters

    def format_lines(self, lines):
        if len(self.formatters) == 0:
            return "".join(lines)
        for formatter in self.formatters:
            formatted = formatter.format_lines(lines)
            lines = StringIO(formatted).readlines()
        return "".join(lines)
