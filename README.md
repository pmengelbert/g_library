# glibrary

glibrary is a simple and effective command-line book search application.  It uses the Google Books API to find books by name, author, publisher, or keyword.  Search results can be selected and stored locally in a 'reading list' for easy reference.

## Getting Started

### Prerequisites

Install Ruby >= 2.6.5 on your system:
#### Linux
```
sudo apt install ruby
or
sudo pacman -S ruby
```
#### MacOS
```
brew install ruby
```

### Installing

Clone the git repo:
```
git clone https://github.com/pmengelbert/g_library.git
```

## Using

glibrary comes with two main 'modes': Search mode and List mode.  For more information, run the following:
```
ruby g_library.rb
```

You will see output like this:

```
Usage: glibrary [options...] [query]
    -t, --title=TITLE                Specify a title keyword
    -a, --author=AUTHOR              Specify an author keyword
    -p, --publisher=PUBLISHER        Specify a publisher keyword
    -f, --lib-file=LIBFILE           Select a library save file
    -l, --library                    See your library; ignores all search options
					default library file is [repository_root]/saved_libraries/library.json
    -h, --help                       Prints this help
[query]: all other arguments will be treated as general search keywords

```

### Search mode

Search mode uses 0-3 flags, "-t", "-a", "-p", indicating title search, author search, and publisher search, respectively.
Any other arguments will be interpreted as a single general-purpose search string.  Take the following, for example:
```
ruby g_library.rb -p "signet" -a "dickens" great expectations
```

In this situation, glibrary will query the Google Books database for books from the publisher "signet", by the author "dickens", and with the general keyword string "great expectations".

#### Saving books to your reading list
You will then be asked if you want to save one of the five results to your reading list.  Pick a number, and it will be saved.  You can view your reading list in List mode (see below)

#### Using a different library file
If you want to save to a library file other than the default, call glibrary with the -f (--lib-file=) flag:
```
ruby g_library.rb -p "signet" -a "dickens" -f /tmp/library.json
```

### List mode
Whenever the "-l" flag is used, glibrary enters List mode, and will not search.  List mode shows your saved 'reading list', which is populated in search mode.

#### Using a different library file
If you want to display a library file other than the default, call glibrary with the -f (--lib-file=) flag.
```
ruby g_library.rb -l -f /tmp/library.json
```

## Running the tests

All following commands are run relative to the repository's main directory.

glibrary comes with a suite of unit tests, in the following files:
```
test/book_search_test.rb
test/user_book_test.rb
test/user_library_test.rb
```

Run all the tests at once with:
```
ruby test/unit_tests.rb
```

## Built With

* [Ruby](https://www.ruby-lang.org) - The language used
* [Google Books API](https://developers.google.com/books/docs/v1/using) - A magnificent resource

## Authors

* **Peter Engelbert**- [pmengelbert](https://github.com/pmengelbert)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Thanks to 8th Light for the great opportunity!
