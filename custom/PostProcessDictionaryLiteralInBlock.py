# PostProcessDictionaryLiteralInBlock.py
# Used to fixup a file that may have been modified by PreProcessDictionaryLiteralInBlock.
# This script should always run if PreProcessDictionaryLiteralInBlock is used (not dependent on success) since PreProcessDictionaryLiteralInBlock *will cause compilation failures* if not processed by this script.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2016 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class PostProcessDictionaryLiteralInBlock(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []

        for line in lines:
            if "/*SC@*/" in line:
                # Undo the HACK from PreProcessDictionaryLiteralInBlock (and a space that may have been added as well).
                post_processed = line.replace("/*SC@*/ ", "@").replace("/*SC@*/", "@")
                lines_to_write.append(post_processed)
            else:
                lines_to_write.append(line)

        return "".join(lines_to_write)

    
if __name__ == "__main__":
    PostProcessDictionaryLiteralInBlock().run()
