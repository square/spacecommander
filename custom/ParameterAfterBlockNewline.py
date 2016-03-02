# ParameterAfterBlockNewline.py
# Puts parameters following a block argument back on the same line instead of REALLY indenting on the next.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2016 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class ParameterAfterBlockNewline(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []
        preceding_line_block_literal_param = False

        for line in lines:
            stripped_line = line.strip()
            indentation_len = len(line) - len(line.lstrip())
            # Some rough heuristics to determine if there's a stray, floating param which broke off from a message send
            final_adrift_param = preceding_line_block_literal_param and stripped_line.endswith(";") and indentation_len > 8
            adrift_param = preceding_line_block_literal_param and stripped_line.endswith(")") and indentation_len > 8 
            if final_adrift_param:
                preceding_line_block_literal_param = False

            if final_adrift_param or adrift_param:
                block_param_line = lines_to_write[-1].rstrip()
                lines_to_write[-1] = block_param_line + " " + line.lstrip()
                continue

            # Match "}," exactly, 
            if stripped_line == "},":
                preceding_line_block_literal_param = True
            # also match a line that starts with a brace, and has a parameter and is not the end of a statement.
            elif stripped_line.startswith("} ") and ":" in stripped_line and ";" not in stripped_line and "{" not in stripped_line:
                preceding_line_block_literal_param = True
            else:
                preceding_line_block_literal_param = False

            lines_to_write.append(line)

        return "".join(lines_to_write)

    
if __name__ == "__main__":
    ParameterAfterBlockNewline().run()
