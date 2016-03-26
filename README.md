# [ Space Commander]

**[ Space Commander]** provides tools which enable a team of iOS developers to commit Objective-C code to a git repository using a unified style format, without requiring any manual fixup.

![Corgi image](banner.jpg)

You can use it to:

* Enforce formatting conventions before code is committed.
* Format code with a single command (both individual files or the entire repo).
* Fail a build (during a pull request) if unformatted code made it into the branch.

At Square, **[ Space Commander]** has streamlined iOS development, especially when it comes to pull requests. Applying formatting standards no longer requires manual developer attention; that time is better spent elsewhere!

You may wish to fork **[ Space Commander]** to apply your team's particular set of formatting rules (more details below), or clone to enjoy Square's flavor of Objective-C formatting.

Installation Locally
-------------

To add formatting pre-commit checks to your repo, from the target repo, run `path/to/spacecommander/setup-repo.sh`.

Usage
-------------

After running `setup-repo.sh`, formatting checks will run automatically before every commit.

To format an individual file and modify it in place, run `format-objc-file.sh <file>`. To format it without modification, run `format-objc-file-dry-run.sh <file>`

To format **all** of the Objective-C files in your repository in-place, run `format-objc-files-in-repo.sh`.

Details
-------------

To install the pre-commit hook, each developer on the project runs the setup script. This installs a precommit hook which will verify that code is formatted before the commit succeeds. 

If there were formatting errors during the commit, a script to fixup code automatically can be run in order to commit without error.

At Square, this formatting repository is referenced as a submodule of a larger iOS project, so that the formatting rules and scripts are locked to a revision of the parent repository.
This way, we can check the formatting as part of the build process, and fail the build if the formatting is not current (we can also check out older SHAs without any difficulty).

`clang-format` expects the custom rules file to exist in the same directory that the command is run from, and so a `.gitignore`-d symlink of the rules file is added to the target repository. It is a symlink so that the developer only needs to update the git SHA of the formatting repository to get the latest formatting rules from upstream.

Configuration
-------------

To format files only within selected directories, specify the name each directory in a file named `.formatting-directory`, separated by newlines (and without whitespace escaped). Otherwise, all Objective-C files tracked in the repo will be checked.

To ignore files within directories, add the name of each directory on a new line to a file named `.formatting-directory-ignore`.

To modify the formatting output, edit the following:

* `.clang-format` for built in `clang-format` options.
* `format-objc-file-dry-run.sh` and `format-objc-file.sh` for rules that are implemented in `custom/`.
* `Testing Support/` files to validate your changes.

Add `#pragma Formatter Exempt` or `// MARK: Formatter Exempt` as the first line of the file if the formatter should ignore it.

Installation for Pull Request Validation
-------------

*The following instructions are Square-specific. We use a build system called **mobuild**. The hook that we use, which can be integrated into other build systems, is `format-objc-mobuild`*

If you want style checking as a mandatory step to get a mergeable PR, do the following:

* Add this repository as a [cocoapod](https://guides.cocoapods.org/using/getting-started.html), or add it as a submodule in a `Scripts/` directory.
* Ensure that your repository has setup `.sqiosbuild.json` and `.stashkins` files at the top level (more info on the Square wiki page titled *All About Mobuild*).
* The build machines are setup to check for the above conditions, and if they're met, automatically run `format-objc-mobuild`.
* Open a PR with a modified Objective-C file to verify these checks are running.

Updating Style Options
-------------

Change formatting policies by modifying `.clang-format`. Available style options are listed on the [clang website](http://clang.llvm.org/docs/ClangFormatStyleOptions.html).

Please also update `UnformattedExample.m` (under `./Testing Support/`) with an example of code that your formatting changes should correct.

Then, update `FormattedExample.m` (in the same place) with the expected result, and verify that your changes produce the desired result by running a simple test:
`./test.sh`

Custom Formatters
-------------

`clang-format` is fantastic and we love it, but it has some limitations. We've added our own ad-hoc formatting capabilities through scripts which live in `custom/`. If you add a custom file formatting script to `custom/`, invoke it in `format-objc-file.sh` and `format-objc-file-dry-run.sh` and add examples of input / output to files in `Testing Support/`.

Undesired Result?
-------------

The formatter can't do everything. It may occasionally produce an undesirable result, in which case you can either:

* Refactor code to produce a line that is simpler and less confusing to the formatter.
* Use `// clang-format off` and `// clang-format on` to selectively enable/disable `clang-format` for specific lines of a file.
* Add `#pragma Formatter Exempt` or `// MARK: Formatter Exempt` as the first line of the file, and it will not be formatted at all.
* [Wislawa Szymborska](http://en.wikipedia.org/wiki/Wis%C5%82awa_Szymborska) said "All imperfection is easier to tolerate if served up in small doses." **[ Space Commander]** will remove nearly all formatting imperfections, but you may need to tolerate an occasional deviation from the expected result.

Contributing
-------------

We’re glad you’re interested in **[ Space Commander]**, and we’d love to see where you take it. Please read our [contributing guidelines](Contributing.md) prior to submitting a Pull Request.

Thanks, and happy formatting!
