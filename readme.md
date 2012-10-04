Urchin 2
====

Tests are organized recursively in directories, where the names of the files
and directories have special meanings.

    tests/
      setup
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

Directories are processed in a depth-first order. When a particular directory
is processed, `setup` is run before everything else in the directory, including
subdirectories. Use `urchin_export`, which works like `export`, to set variables
in the setup function and make them available to other files in the same
directory.

`teardown` is run after everything else in the directory. The "everything else"
actually only includes files whose names contain "test". The test passes if the
file exits 0; otherwise, it fails.

Aside from files named '`setup`' or '`teardown`', files and directories are run
only if they start with '`test`'. Thus, fixtures and libraries can be included
sloppily within the test directory tree.
