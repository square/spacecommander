
from AggregatedFormatter import AggregatedFormatter
from LiteralSymbolSpacer import LiteralSymbolSpacer
from InlineConstructorOnSingleLine import InlineConstructorOnSingleLine
from MacroSemicolonAppender import MacroSemicolonAppender
from DoubleNewlineInserter import DoubleNewlineInserter

if __name__ == "__main__":
    formatters = [
        LiteralSymbolSpacer(),
        InlineConstructorOnSingleLine(),
        MacroSemicolonAppender(),
        DoubleNewlineInserter()
    ]
    AggregatedFormatter(formatters).run()
