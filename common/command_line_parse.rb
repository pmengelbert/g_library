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
      initialize_and_print_library(filename)
      exit
    end

    opts.on("-h", "--help", "Prints this help") do
      print_help_message(opts)
      exit
    end

  end.parse!

  return [filename, o]

end

