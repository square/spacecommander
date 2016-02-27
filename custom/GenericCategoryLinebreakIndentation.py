# GenericCategoryLinebreakIndentation.py
# Undoes extraneous linebreak and indentation when a category has a generic expression.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class GenericCategoryLinebreakIndentation(AbstractCustomFormatter):
    def format_lines(self, lines):
        lines_to_write = []
        entered_generic_interface = False
        entered_generic_category = False

        for line in lines:
            stripped_line = line.strip()
            # We are on the next line with the category description because of an extraneous linebreak
            if entered_generic_interface and stripped_line.startswith("("):
                entered_generic_category = True
                # Remove the extra line break
                interface_line = lines_to_write[-1].rstrip()
                lines_to_write[-1] = interface_line + " " + line.lstrip()
                continue
            else:
                # reset if we don't find a category after the first line
                entered_generic_interface = False

            if entered_generic_category and len(line.lstrip()) > 0:
                # Removes unwanted indentation
                lines_to_write.append(line.lstrip())
            else:
                lines_to_write.append(line)

            if stripped_line.startswith("@interface") and "<" in stripped_line and ">" in stripped_line:
                entered_generic_interface = True
            elif stripped_line.startswith("@end"):
                entered_generic_interface = False
                entered_generic_category = False

        return "".join(lines_to_write)

    
if __name__ == "__main__":
    GenericCategoryLinebreakIndentation().run()
