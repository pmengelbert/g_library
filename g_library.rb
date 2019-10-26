#!/usr/bin/env ruby
require 'json'
require 'optparse'
require 'io/console'

require_relative 'common/api_query'
require_relative 'common/google_api_url'
require_relative 'classes/book_search'
require_relative 'classes/user_book'
require_relative 'classes/user_library'
require_relative 'common/errors'

ARGV << '-h' if ARGV.empty?

#make sure the -l flag is process *after* the -f flag, by putting it at the end
ARGV << ARGV.delete("-l") if ARGV.include?("-l")

#default filename for saved reading list
filename = File.dirname(File.expand_path(__FILE__)) + "/saved_libraries/library.json"

#initialize the hash which will hold the search parameters
o = {}

#parse the command-line options
OptionParser.new do |opts|
  opts.banner = "Usage: ruby g_library.rb [options...] [query]"
  #sets 'library-mode'
  library = opts.default_argv.include?("-l")

  opts.on("-t", "--title=TITLE", "Specify a title keyword") do |t|
    o[:title] = t
  end

  opts.on("-a", "--author=AUTHOR", "Specify an author keyword") do |a|
    o[:author] = a
  end

  opts.on("-p", "--publisher=PUBLISHER", "Specify a publisher keyword") do |p|
    o[:publisher] = p
  end

  opts.on("-f", "--lib-file=LIBFILE", "Select a library save file") do |libfile|
    filename = File.absolute_path(libfile)
    unless File.exist?(filename)
      (puts "Library file not found, cannot display."; exit) if library
      puts "Creating new file"
    end
  end

  opts.on("-l", "--library", "See your library; ignores all search options
          \t\t\t\t\tdefault library file is [repository_root]/saved_libraries/library.json") do

    #substitute \ for / if the machine is running windows
    filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }


    #print out the library and exit the program
    l = UserLibrary.new(filename)
    l.pretty_print
    exit
  end

  opts.on("-h", "--help", "Prints this help") do
    puts ""
    puts opts
    puts "[query]: all other arguments will be treated as general search keywords"
    puts ""
    exit
  end

end.parse!

#substitute \ for / if the machine is running windows
filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /C:\\Windows/i }

# Create or load the library, depending on whether or not the file already exists.
l = UserLibrary.new(filename)

#initialize the 
#perform the search, and display the results.
begin
  s = BookSearch.new(search: ARGV.join('+'), title: o[:title], author: o[:author], publisher: o[:publisher])

  #see BookSearch definition in classes/book_search.rb
  #the each method (and all Enumerable methods, like map) only operate on
  #the first five matches.
  books = s.map { |info| UserBook.new(info) }

  #print the resuls
  puts ""
  books.each_with_index do |b, i|
    keys = %w[title author publisher]
    n = i+1
    puts "-"*5 + "Match ##{n}" + "-"*5 
    keys.each do |k|
      puts "%s: %s" % [k.capitalize, b[k]]
    end
    puts ""
  end

  print "Enter a number (1-5) to add a book to your reading list:\n(or any other key to quit)\n"

  selection = STDIN.getch.chomp.to_i
  i = selection - 1
  puts ""
  exit if i < 0 or i > 4

  #add a book to the user's library
  l.add(books[i])
  l.save

rescue SearchError 
  puts "\nThere was an error with your query; be careful to format it well"
  puts ""
  exit
rescue NoResults
  puts "\nNo results."
  puts ""
  exit
end
