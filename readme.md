
      ,  ,  ,_     _,  , ,   ___, ,  , 
      |  |  |_)   /    |_|, ' |   |\ | 
     '\__| '| \  '\_  '| |   _|_, |'\| 
    `  '  `    `  ' `  '     '  ` 

Urchin is an experimental language-agnostic lightweight cross-platform test skeleton
written in POSIX-compliant shell, originally designed for test-driven server deployment
at <a href="https://scraperwiki.com">ScraperWiki</a>.

## Install
Downlolad Urchin like so (as root)

    wget -O /usr/local/bin https://raw.github.com/scraperwiki/urchin/master/urchin
    chmod +x /usr/local/bin/urchin

Now you can run it.

    urchin

## Writing tests
Make a root directory for your tests. Inside it, put executable files that
exit `0` on success and something else on fail. Non-executable files and hidden
files (dotfiles) are ignored, so you can store fixtures right next to your
tests. Run urchin from inside the tests directory.

## More about writing tests
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
          fixtures/
            thingy.pdf
          test_thingy
      teardown

Directories are processed in a depth-first order. When a particular directory
is processed, `setup` is run before everything else in the directory, including
subdirectories. Use `urchin_export`, which works like `export`, to set variables
in the setup function and make them available to other files in the same
directory.

`teardown` is run after everything else in the directory. The "everything else"
actually only includes files whose names contain "test". The test passes if the
file exits 0; otherwise, it fails.

Files are only run if they are executable, and files beginning with `.` are
ignored. Thus, fixtures and libraries can be included
sloppily within the test directory tree.
