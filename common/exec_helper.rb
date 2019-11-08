def process_args!(args = ARGV)
  args << '-h' if args.empty?
  args << args.delete("-l") if args.include?("-l")
end

def prepare_filename_for_os!(filename)
  filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
end

def print_book_results(books)
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

end

def get_book_number
  selection = STDIN.getch.chomp.to_i
  i = selection - 1
  puts ""
  exit if i < 0 or i > 4
end

def perform_search(o)
  s = BookSearch.new(search: ARGV.join('+'), title: o[:title], author: o[:author], 
                     publisher: o[:publisher])
end
