
from AggregatedFormatter import AggregatedFormatter
from GenericCategoryLinebreakIndentation import GenericCategoryLinebreakIndentation
from ParameterAfterBlockNewline import ParameterAfterBlockNewline
from HasIncludeSpaceRemover import HasIncludeSpaceRemover

if __name__ == "__main__":
    formatters = [
        GenericCategoryLinebreakIndentation(),
        ParameterAfterBlockNewline(),
        HasIncludeSpaceRemover(),
    ]
    AggregatedFormatter(formatters).run()
