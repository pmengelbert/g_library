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

End with an example of getting some data out of the system or using it for a little demo

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
