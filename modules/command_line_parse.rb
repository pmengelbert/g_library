require_relative 'errors'

module CommandLineParse
  require 'optparse'
  include Errors

  def handle_nonexistent_file
    (puts "Library file not found, cannot display."; exit)
    puts "Creating new file"
  end

  def print_help_message(opts)
    puts ""
    puts opts
    puts "[query]: all other arguments will be treated as general search keywords"
    puts ""
  end



  def process_filename!(libfile)
    @filename = File.absolute_path(libfile)
    handle_nonexistent_file if ARGV.include?("-l") && !File.exist?(@filename)
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
        process_filename!(libfile)
      end

      opts.on("-l", "--library", "See your reading list; ignores all search options") do
        options = nil
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

end
