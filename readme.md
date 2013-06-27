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

    cd urchin/tests
    ../urchin .    

The above command will run the tests in your login shell; to test cross-shell
compatibility, run this.

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
