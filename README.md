# glibrary

glibrary is a simple and effective command-line book search application.  It uses the Google Books API to find books by name, author, publisher, or keyword.  Search results can be selected and stored locally in a 'reading list' for easy reference. glibrary runs anywhere you have the ruby interpreter installed; it has been tested on Linux, MacOS, and Windows.

A rudimentary web version of this application can be found [Here](http://3.130.246.225:3001).

# Getting Started

## Prerequisites

Install Ruby >= 2.6.5 on your system:
### Linux
```
% sudo apt install ruby
```
or
```
% sudo pacman -S ruby
```
### MacOS
```
% brew install ruby
```

### Windows
Visit [rubyinstaller.org](https://rubyinstaller.org/) for a standalone installer.

# Installing

## As a gem
glibrary will work best when installed as a gem.  At the command-line, type the following:
```
% gem install glibrary
```
You may need administrator privileges to install gems.  Usually you won't, but in testing on Windows I found that administrator privileges were sometimes necessary.

## Cloning the repo
```
% git clone https://github.com/pmengelbert/g_library.git
```
Directly after cloning the repo, run the program by executing the following:
```
% cd g_library
% bin/glibrary --help
```
NOTE: The use instructions going forward will assume that you have installed glibrary as a gem, which gives access
to the glibrary executable file.

# Using

glibrary comes with two main 'modes': Search mode and List mode.  For more information, run the following:
```
% glibrary --help
```

You will see output like this:
```
Usage: glibrary [options...] [query]
    -t, --title=TITLE                Specify a title keyword
    -a, --author=AUTHOR              Specify an author keyword
    -p, --publisher=PUBLISHER        Specify a publisher keyword
    -f, --lib-file=LIBFILE           Select a library save file. Otherwise, a default save file will be used.
    -l, --library                    See your library; ignores all search options
    -h, --help                       Prints this help
[query]: all other arguments will be treated as general search keywords

```

## Search mode

Search mode uses 0-3 flags, "-t", "-a", "-p", indicating title search, author search, and publisher search, respectively.
Any other arguments will be interpreted as a single general-purpose search string.  Take the following, for example:
```
% glibrary -p "signet" -a "dickens" great expectations
```

In this situation, glibrary will query the Google Books database for books from the publisher "signet", by the author "dickens", and with the general keyword string "great expectations".

### Saving books to your reading list
You will then be asked if you want to save one of the five results to your reading list:  
```
1.)--w_QxbUaiJPMC-----
Title: Great Expectations
Author: Charles Dickens
Publisher: Signet

2.)--bYGM0MbO3ZkC-----
Title: Bleak House
Author: Charles Dickens
Publisher: Univ. Press of Mississippi

3.)--vkFO5b2mMYIC-----
Title: Oliver Twist
Author: Charles Dickens
Publisher: Signet

4.)--tV4Kh6qMU24C-----
Title: The Pickwick Papers
Author: Charles Dickens
Publisher: Univ. Press of Mississippi

5.)--T7dSvwEACAAJ-----
Title: A Christmas Carol
Author: Charles Dickens
Publisher: 

Enter a number (1-5) to add a book to your reading list (or q to quit): 
```

Pick a number, and it will be saved.  You can view your reading list in List mode (see below)

### Using a different library file
If you want to save to a library file other than the default, call glibrary with the -f (--lib-file=) flag:
```
% glibrary -p "signet" -a "dickens" -f /tmp/library.json
```

## List mode
Whenever the "-l" flag is used, glibrary enters List mode, and will not search.  List mode shows your saved 'reading list', which is populated in search mode.  In List mode, you will be prompted to delete any books that you no longer want to keep in your list.
```
1.)--OfgVAAAAQBAJ-----
Title: A Practical Approach to 18th Century Counterpoint
Author: Robert Gauldin
Publisher: Waveland Press

2.)--z1k_AxXUvmEC-----
Title: The Brothers Karamazov
Author: Fyodor Dostoevsky
Publisher: Macmillan

3.)--PBYjpKypCskC-----
Title: Classical Form
Author: William E. Caplin
Publisher: Oxford University Press

4.)--VXH3pnqDARoC-----
Title: The Study of Fugue
Author: Alfred Mann
Publisher: Courier Corporation

5.)---SYiAAAAQBAJ-----
Title: The Logic Book
Author: Merrie Bergmann, James Moor, Jack Nelson
Publisher: McGraw-Hill Higher Education

Select a book number to delete, or type "q" to quit:
```

### Using a different library file
If you want to display a library file other than the default, call glibrary with the -f (--lib-file=) flag.
```
% glibrary -l -f /tmp/library.json
```

# Running the tests

NOTE: You must clone the git repository in order to run the tests.  All following commands are run 
relative to the repository's main directory.

glibrary comes with a suite of unit tests, in the following files:
```
tests/book_search_test.rb
tests/command_line_parse_test.rb
tests/exec_helper_test.rb
tests/unit_tests.rb
tests/user_book_test.rb
tests/user_library_test.rb
tests/user_prompt_test.rb
```

Run all the tests at once with:
```
% ruby tests/unit_tests.rb
```

# Built With

* [Ruby](https://www.ruby-lang.org) - The language used
* [Google Books API](https://developers.google.com/books/docs/v1/using) - A magnificent resource

# Authors

* **Peter Engelbert**- [pmengelbert](https://github.com/pmengelbert)

# License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

# Acknowledgments

* Thanks to 8th Light for the great opportunity!
