# HasIncludeSpaceRemover.py
# clang-format gets confused by __has_include() macro when there is a file path present.
#
# If a filename is specified as a parameter, it will change that file in place.
# If input is provided through stdin, it will send the result to stdout.
# Copyright 2015 Square, Inc

from AbstractCustomFormatter import AbstractCustomFormatter

class HasIncludeSpaceRemover(AbstractCustomFormatter):
    def format_lines(self, lines):

        lines_to_write = []
        for line in lines:
            to_append = line
            if "__has_include(" in line: 
                has_include_prefix = line.split("__has_include(")[0]
                has_include_suffix = line.split("__has_include(")[1]
                if ")" in has_include_suffix:
                    has_include_interior = has_include_suffix.split(")")[0]
                    # Remove the extra space that clang-format erroneously added.
                    new_interior = has_include_interior.replace(" / ", "/")
                    to_append = line.replace(has_include_interior, new_interior)

            lines_to_write.append(to_append)

        return "".join(lines_to_write)

if __name__ == "__main__":
    HasIncludeSpaceRemover().run()
