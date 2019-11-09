require 'optparse'

def handle_nonexistent_file(filename, library)
  (puts "Library file not found, cannot display."; exit) if library
  puts "Creating new file"
end

def initialize_and_print_library(filename)
  l = UserLibrary.new(filename)
  l.pretty_print
end

def print_help_message(opts)
  puts ""
  puts opts
  puts "[query]: all other arguments will be treated as general search keywords"
  puts ""
end

def ask_to_delete_from(library)
  while true
    begin
      print "Select a book number to delete, or type \"q\" to quit: "
      selection = STDIN.gets.strip
      raise SelectionError unless selection =~ /\A([0-9]+|[qQ])\Z/
      raise UserQuits if selection =~/\A[qQ]\Z/
      selection = selection.to_i
      selection = selection - 1
      raise DataError unless selection <= library.size
      library.delete(selection)
      library.pretty_print
      puts "Your library now looks like this."
      puts ""
    rescue SelectionError
      puts "\nSorry, your selection was invalid. Please try again."
    rescue DataError
      puts "\nSorry, your selection was invalid. Make sure your selection is in the provided range."
    rescue UserQuits
      library.save
      puts "\nEnjoy your day."
      exit
    end
  end
end


def command_line_parse!(filename, o)

  OptionParser.new do |opts|
    opts.banner = "Usage: ruby g_library.rb [options...] [query]"
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

    opts.on("-f", "--lib-file=LIBFILE",
            "Select a library save file. Otherwise, a default save file will be used.") do |libfile|

      filename = File.absolute_path(libfile)
      handle_nonexistent_file(filename) unless File.exist?(filename, library)
    end

    opts.on("-l", "--library", "See your library; ignores all search options") do
      prepare_filename_for_os!(filename)
      (l = UserLibrary.new(filename)).pretty_print
      selection = ask_to_delete_from(l)
      exit
    end

    opts.on("-h", "--help", "Prints this help") do
      print_help_message(opts)
      exit
    end

  end.parse!

  return [filename, o]

end

