def process_args!(args = ARGV)
  args << '-h' if args.empty?
  args << args.delete("-l") if args.include?("-l")
end

def prepare_filename_for_os!(filename)
  filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
end

def get_book_number
  print "Enter a number (1-5) to add a book to your reading list:\
  (or any other key to quit)\n"
  selection = STDIN.getch.chomp.to_i
  i = selection - 1
  puts ""
  exit if i < 0 or i > 4
  return i
end

def perform_search(o)
  s = BookSearch.new(search: ARGV.join('+'), title: o[:title], author: o[:author], 
                     publisher: o[:publisher])
end
