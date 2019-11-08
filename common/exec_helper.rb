def process_args!(args)
  args << '-h' if args.empty?
  args << args.delete("-l") if args.include?("-l")
end

def prepare_filename_for_os!(filename)
  filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
end

def command_line_parse!(argv, filename, o)

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

    opts.on("-f", "--lib-file=LIBFILE", "Select a library save file. Otherwise, a default save file will be used.") do |libfile|
      filename = File.absolute_path(libfile)
      unless File.exist?(filename)
        (puts "Library file not found, cannot display."; exit) if library
        puts "Creating new file"
      end
    end

    opts.on("-l", "--library", "See your library; ignores all search options") do
      prepare_filename_for_os!(filename)
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

  return filename

end
