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

filename = File.dirname(File.expand_path(__FILE__)) + "/saved_libraries/library.json"

o = {}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby g_library.rb [options...] [query]"

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
    if File.exist(File.absolute_path(libfile))
      filename = libfile
    else
      puts "Library file not found"
      exit
    end
  end

  opts.on("-l", "--library", "See your library; ignores all search options\n\t\t\t\t\tdefault library file is [repository_root]/saved_libraries/library.json") do
    filename.gsub!(/\// '\\') if ENV.values.any? { |v| v =~ /C:\\Windows/i }
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

filename.gsub!(/\// '\\') if ENV.values.any? { |v| v =~ /C:\\Windows/i }
l = UserLibrary.new(filename)


begin
  s = BookSearch.new(search: ARGV.join('+'), title: o[:title], author: o[:author], publisher: o[:publisher])
  books = s.map { |info| UserBook.new(info) }

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
rescue SearchError 
  puts "\nThere was an error with your query; be careful to format it well"
  puts ""
  exit
rescue NoResults
  puts "\nNo results."
  puts ""
  exit
end

print "Enter a number (1-5) to add a book to your reading list:\n(or any other key to quit)\n"

selection = STDIN.getch.chomp.to_i
i = selection - 1
puts ""
exit if i < 0 or i > 4 or !i.is_a?(String)

l.add(UserBook.new(s[i]))
l.save
