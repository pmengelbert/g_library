#!/usr/bin/env ruby
require 'json'
require 'optparse'

require_relative 'common/api_query'
require_relative 'common/google_api_key'
require_relative 'classes/book_search'
require_relative 'classes/user_book'
require_relative 'classes/user_library'
require_relative 'common/search_error'

o = {}
OptionParser.new do |opts|
  opts.banner = "Usage: glibrary [o...] [query]"

  opts.on("-t", "--title=TITLE", "Specify a title keyword") do |t|
    o[:title] = t
  end

  opts.on("-a", "--author=AUTHOR", "Specify an author keyword") do |a|
    o[:author] = a
  end

  opts.on("-p", "--publisher=PUBLISHER", "Specify a publisher keyword") do |p|
    o[:publisher] = p
  end

  opts.on("-l", "--library", "See your library; ignores all other options") do |p|
    l = UserLibrary.new("saved_libraries/library.json")
    l.pretty_print
    exit
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    puts "[query]: all other arguments will be treated as general search keywords"
    exit
  end

end.parse!

l = UserLibrary.new("saved_libraries/library.json")

begin
  s = BookSearch.new(search: ARGV.join(' '), title: o[:title], author: o[:author], publisher: o[:publisher])
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
  puts "\nNo results."
  puts ""
end

print "Pick a book to add to your library (or 0 to quit): "
selection = gets.chomp.to_i
i = selection - 1
exit if i == -1
l.add(UserBook.new(s[i]))
l.save
