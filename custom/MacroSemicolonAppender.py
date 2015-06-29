# MacroSemicolonAppender.py
# Adds semicolons to macros which end with parens, since otherwise clang-format gets confused.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class MacroSemicolonAppender(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []
        preceding_line_ends_with_backslash = False
        preceding_line_ends_with_comma = False
        for line_number, line in enumerate(lines):
            # Criteria for a macro in need of semicolon:
            # - Starts with uppercase letter, ends with )
            stripped_line = line.strip()
            needs_semicolon = len(stripped_line) > 0 and stripped_line[0].isupper() and stripped_line.endswith(")")
            # - The line doesn't contain any spaces before a ( [that might mean it's a C function]
            needs_semicolon = needs_semicolon and not " " in stripped_line.split("(")[0].strip()
            # - The next line (if there is one) does not start with a brace.
            if (line_number + 1) < len(lines) and lines[line_number + 1]:
                for brace in "{", "}", "[", "]":
                    needs_semicolon = needs_semicolon and not lines[line_number + 1].lstrip().startswith(brace)
            # This line isn't part of a macro definition (we look at the previous line to see if it ended with a \)
            needs_semicolon = needs_semicolon and not preceding_line_ends_with_backslash
            # If the prior line ends with a comma, we're part of a larger statement.
            needs_semicolon = needs_semicolon and not preceding_line_ends_with_comma

            if needs_semicolon:
                line = line.rstrip() + ";\n"

            lines_to_write.append(line)

            if stripped_line.endswith("\\"):
                preceding_line_ends_with_backslash = True
            else:
                preceding_line_ends_with_backslash = False
            if stripped_line.endswith(","):
                preceding_line_ends_with_comma = True
            else:
                preceding_line_ends_with_comma = False

        return "".join(lines_to_write)

if __name__ == "__main__":
    MacroSemicolonAppender().run()
