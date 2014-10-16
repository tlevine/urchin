                       __    _     
      __  ____________/ /_  (_)___ 
     / / / / ___/ ___/ __ \/ / __ \
    / /_/ / /  / /__/ / / / / / / /
    \__,_/_/   \___/_/ /_/_/_/ /_/ 

Urchin is a test framework for shell. It is implemented in
portable /bin/sh and should work on GNU/Linux, Mac OS X, and
other Unix platforms.

## Try it out
Urchin's tests are written in Urchin, so you can run them to see what Urchin
is like. Clone the repository

    git clone git://github.com/scraperwiki/urchin.git

Run the tests

    cd urchin
    ./urchin tests

The above command will run the tests in your systems default
shell, /bin/sh (on recent Ubuntu this is dash, but it could be
ksh or bash on other systems); to test urchin's own cross-shell compatibility,
run this:

    cd urchin
    ./cross-shell-tests

## Globally
Download Urchin like so (as root) (or use npm, below):

    cd /usr/local/bin
    wget https://raw.github.com/scraperwiki/urchin/master/urchin
    chmod +x urchin

Can be installed with npm too:

    npm install -g urchin

Now you can run it.

    urchin <test directory>

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

### Writing cross-shell compatibility tests for testing shell code

While you could write your test scripts to explicitly invoke the functionality
to test with various shells, a more flexible approach is to pass the shell
to use via environment variable `TEST_SHELL`.  
(Note that urchin always invokes the test scripts themselves directly, so whatever shebang line
_they_ specify is respected.)

On invocation of urchin, prepend an environment-variable definition
defining the shell to test with, e.g.: `TEST_SHELL=zsh urchin test`.
To test with multiple shells in sequence, use something like:

    for shell in sh bash ksh zsh; do
      TEST_SHELL=$shell urchin ./tests
    done

To use this approach, you must design your test scripts accordingly:

#### Writing a cross-shell compatibility test script controlled by environment variable `TEST_SHELL`

Note: If you've cloned urchin's repository, find a demonstration of the techniques below in subfolder `tests/Cross-shell test demo`.

Your test scripts must modify their behavior based on whether the environment variable
`TEST_SHELL` has a value or not:

- If `TEST_SHELL` has a value, the script to test must be passed (as an argument) to the shell specified there, thus overriding that script's shebang line.
- Otherwise, the script must be invoked directly, as usual (letting its shebang line control what executable runs it).

The following helper function, when placed at the top of your test script, facilitates this:

    x() { if [ -n "$TEST_SHELL" ]; then "$TEST_SHELL" -- "$@"; else "$@"; fi }

Then use `x` to invoke the shell script to test, e.g., `x ../foo`

Alternatively, if the shell code to test must be _sourced_ (because that's how it will be run in practice), place the following
at the top of your test script:

    [ -n "$TEST_SHELL" ] && TEST_SHELL= exec "$TEST_SHELL" -- "$0" "$@"

If `TEST_SHELL` has a value, this re-invokes the test script itself with the specified shell.  
Place the command that sources the shell code to test (e.g., `. ../foo`) below that line, and it will be run by the desired shell.

## Alternatives to Urchin
Alternatives to Urchin are discussed in
[this blog post](https://blog.scraperwiki.com/2012/12/how-to-test-shell-scripts/).
