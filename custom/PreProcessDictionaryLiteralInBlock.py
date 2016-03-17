# PreProcessDictionaryLiteralInBlock.py
# Preprocess a degenerate case with dictionary literals inside blocks to prevent clang-format confusion.
# !!! This will break compilation if not paired with PostProcessDictionaryLiteralInBlock.py !!!
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2016 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class PreProcessDictionaryLiteralInBlock(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []

        for line in lines:
            stripped_line = line.strip()
            if stripped_line.endswith(":@{"):
                # HACK: Comment out the @ so the dictionary is formatted like a block would be.
                # Look for this token after clang-format runs and replace it with @ again.
                pre_processed = line.replace(":@{", ":/*SC@*/{")
                lines_to_write.append(pre_processed)
            else:
                lines_to_write.append(line)

        return "".join(lines_to_write)

    
if __name__ == "__main__":
    PreProcessDictionaryLiteralInBlock().run()
