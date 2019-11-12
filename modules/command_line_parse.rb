require 'optparse'

def abort_library_mode
  puts "Library file not found, cannot display."
  exit
end

def print_help_message(opts)
  puts ""
  puts opts
  puts "[query]: all other arguments will be treated as general search keywords"
  puts ""
end

def get_cli_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: glibrary [options...] [query]"

    opts.on("-t", "--title=TITLE", "Specify a title keyword") do |t|
      options[:title] = t
    end

    opts.on("-a", "--author=AUTHOR", "Specify an author keyword") do |a|
      options[:author] = a
    end

    opts.on("-p", "--publisher=PUBLISHER", "Specify a publisher keyword") do |p|
      options[:publisher] = p
    end

    opts.on("-f", "--lib-file=LIBFILE",
            "Select a library save file. Otherwise, a default save file will be used.") do |libfile|
      abort_library_mode if ARGV.include?("-l") && !File.exist?(filename)
    end

    opts.on("-l", "--library", "See your reading list; ignores all search options") do
      return
    end

    opts.on("-h", "--help", "Prints this help") do
      print_help_message(opts)
      exit
    end
  end.parse!

 options[:search] = ARGV.join('+')

 options
end

