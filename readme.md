                       __    _     
      __  ____________/ /_  (_)___ 
     / / / / ___/ ___/ __ \/ / __ \
    / /_/ / /  / /__/ / / / / / / /
    \__,_/_/   \___/_/ /_/_/_/ /_/ 

Urchin is a file-based test harness, normally used for testing shell programs.
It is written in portable shell and should thus work on GNU/Linux, BSD
(including Mac OS X), and other Unix-like platforms.

Urchin is called "Urchin" because
[sea urchins](https://en.wikipedia.org/wiki/Sea_urchin)
have shells called "tests".

## Try it out
Urchin's tests are written in Urchin, so you can run them to see what Urchin
is like. Clone the repository

    git clone git://github.com/tlevine/urchin.git

Run the tests

    cd urchin
    ./urchin tests

The above command will run the tests in your system's default
shell, /bin/sh (on recent Ubuntu this is dash, but it could be
ksh or bash on other systems); to test urchin's cross-shell compatibility,
run this:

    cd urchin
    ./cross-shell-tests

## Install
Urchin is contained in a single file, so you can install it by copying it to a
directory in your `PATH`. For example, you can run the following as root.

    cd /usr/local/bin
    wget https://raw.githubusercontent.com/tlevine/urchin/v0.0.6/urchin
    chmod +x urchin

Urchin can be installed with npm too.

    npm install -g urchin

Now you can run it.

    urchin <test directory>

Run `urchin -h` to get command-line help.

## Writing tests
Make a root directory for your tests. Inside it, put executable files that
exit `0` on success and something else on fail. Non-executable files and hidden
files (dotfiles) are ignored, so you can store fixtures right next to your
tests. Run urchin from inside the tests directory.

Urchin only cares about the exit status, so you can actually write your tests
in any language, not just shell.

## More about writing tests
Tests are organized recursively in directories, where the names of the files
and directories have special meanings.

    tests/
      setup
      setup_dir
      bar/
        setup
        test_that_something_works
        teardown
      baz/
        jack-in-the-box/
          setup
          test_that_something_works
          teardown
        cat-in-the-box/
          fixtures/
            thingy.pdf
          test_thingy
      teardown

Directories are processed in a depth-first order. When a particular directory
is processed, `setup_dir` is run before everything else in the directory, including
subdirectories. `teardown_dir` is run after everything else in the directory.

A directory's `setup` file, if it exists, is run right before each test file
within the particular directory, and the `teardown` file is run right after.

Files are only run if they are executable, and files beginning with `.` are
ignored. Thus, fixtures and libraries can be included sloppily within the test
directory tree. The test passes if the file exits 0; otherwise, it fails.

Tests files and subdirectories are run in ASCIIbetical order within each
directory; that is,
urchin looks for files within a directory in the following manner.

    for file in *; do
      do_something_with_test_file $file
    done

### Writing cross-shell compatibility tests for testing shell code

While you could write your test scripts to explicitly invoke the functionality
to test with various shells, Urchin facilitates a more flexible approach.

The specific approach depends on your test scenario:

* (a) Your test scripts _invoke_ scripts containing portable shell code.
* (b) Your scripts _source_ scripts containing portable shell code.

#### (a) Cross-shell tests with test scripts that _invoke_ shell scripts
Urchin sets the `TEST_SHELL` environment variable so that you may change the
shell with which your tests call other shell programs. To run your test
scripts in multiple shells you must call `$TEST_SHELL` in your tests and then
run urchin with the appropriate option.

In your test scripts, invoke the shell scripts to test via the shell
specified in environment variable `TEST_SHELL` rather than directly;
e.g.: `$TEST_SHELL ../foo bar` (rather than just `../foo bar`).  

On invocation of Urchin, prepend a definition of environment variable
`TEST_SHELL` specifying the shell to test with, e.g.,

    TEST_SHELL=zsh urchin ./tests

To test with multiple shells in sequence, use something like:

    for shell in sh bash ksh zsh; do
      TEST_SHELL=$shell urchin ./tests
    done

If `TEST_SHELL` has no value, Urchin defines it as `/bin/sh`, so the test
scripts can rely on `$TEST_SHELL` always containing a value when Urchin runs
them.

That said, we still recommand that you account for the possibility that
`$TEST_SHELL` does not contain a value so that you may run your test scripts
without Urchin. Supporting this case is very simple; when you invoke scripts
that happen to be in the current directory, be sure to use the prefix `./`,
e.g., `$TEST_SHELL ./baz` rather than `$TEST_SHELL baz`.

#### (b) Cross-shell tests with test scripts that _source_ shell scripts
If you _source_ shell code in your test scripts, it is the test scripts
themselves that must be run with the shell specified.

Urchin supports the `-s <shell>` option, which instructs
Urchin to invoke the test scripts with the specified shell; e.g., `-s bash`.  
(In addition, Urchin sets environment variable `TEST_SHELL` to the specified
shell.)

Note that only test scripts that either have no shebang line at all or
have shebang line `#!/bin/sh` are invoked with the specified shell.
This allows non-shell test scripts or test scripts for specific
shells to coexist with those whose invocation should be controlled by `-s`.

To test with multiple shells in sequence, use something like:

    for shell in sh bash ksh zsh; do
      urchin -s $shell ./tests
    done

Also consider using [shall](https://github.com/mklement0/shall).
It does something similar, but the interface may be more intuitive.

    #!/usr/bin/env shall
    echo This is a test file.

## Alternatives to Urchin
Alternatives to Urchin are discussed in
[this blog post](https://blog.scraperwiki.com/2012/12/how-to-test-shell-scripts/).
