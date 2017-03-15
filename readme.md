                       __    _     
      __  ____________/ /_  (_)___ 
     / / / / ___/ ___/ __ \/ / __ \
    / /_/ / /  / /__/ / / / / / / /
    \__,_/_/   \___/_/ /_/_/_/ /_/ 

Urchin is a portable shell program that runs a directory of Unix-style
programs and produces pretty output. It is normally used for testing
shell programs, where each test case corresponds to a single file in
the directory that Urchin runs.

Urchin is called "Urchin" because
[sea urchins](https://en.wikipedia.org/wiki/Sea_urchin)
have shells called "tests".

## Try it out
Urchin's tests are written in Urchin, so you can run them to see what Urchin
is like. Clone the repository

    git clone git://github.com/tlevine/urchin.git

Run the tests

```sh
cd urchin
./urchin tests
```

## Dependencies
Urchin depends on the following programs.

* sh
* echo
* printf
* mktemp
* readlink
* basename
* dirname
* sed
* grep
* cut
* true
* false
* which
* timeout
* sort

Vanilla installations of modern BSD and GNU systems usually include all
of these programs.

## Install
Urchin is contained in a single file, so you can install it by copying it to a
directory in your `PATH`. For example, you can run the following as root.

```sh
cd /usr/local/bin
wget https://raw.githubusercontent.com/tlevine/urchin/v0.1.0-rc3/urchin
chmod +x urchin
```

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
is processed, `setup_dir` is sourced before everything else in the directory,
including subdirectories. `teardown_dir` is sourced after everything else in
the directory.

A directory's `setup` file, if it exists, is sourced right before each test
file within the particular directory is run, and the `teardown` file is
sourced right after.

Files are only run if they are executable, and files beginning with `.` are
ignored. Thus, fixtures and libraries can be included sloppily within the test
directory tree. The test passes if the file exits 0; otherwise, it fails.

urchin looks for files within a directory in the following manner,

```sh
for file in *; do
  do_something_with_test_file $file
done
```

so files are run in whatever order `*` produces. The order is
configured in your environment, at least in
[GNU systems](https://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021).
Other systems may ignore the locales configured in the environment and
always produce ASCIIbetical order.

Results are always printed in ASCIIbetical order, regardless of what
order the tests ran in.

Below you can see how the locale can affect the order.

```sh
$ printf '!c\n@a\n~b\n' | LC_COLLATE=C sort
!c
@a
~b
$ printf '!c\n@a\n~b\n' | LC_COLLATE=en_US.UTF-8 sort
@a
~b
!c
$ printf '!c\n@a\n~b\n' | sort -d
@a
~b
!c
```

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

Urchin runs tests in multiple different shells by default; Urchin has a
list of default shells, and the following command will run your tests in
all of those shells that Urchin detects.

    ./urchin ./tests

You can override the default list of shells with the `-s` flag.

    urchin -s sh -s ksh ./tests

You can also 

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
This allows non-shell test scripts or test scripts for other languages
or for specific shells to coexist with those whose invocation should be
controlled by `-s`.

## References

On shell programming

* http://blackskyresearch.net/shelltables.txt
* http://blackskyresearch.net/try.sh.txt
