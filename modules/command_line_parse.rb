require_relative 'exec_helper'
require_relative 'user_prompt'
require_relative 'errors'
require_relative '../lib/user_library'

module CommandLineParse
  require 'optparse'
  include ExecHelper
  include UserPrompt
  include Errors

  def handle_nonexistent_file(filename, library)
    (puts "Library file not found, cannot display."; exit) if library
    puts "Creating new file"
  end

  def print_help_message(opts)
    puts ""
    puts opts
    puts "[query]: all other arguments will be treated as general search keywords"
    puts ""
  end


  def command_line_parse!(filename, o, suppress = nil)

    OptionParser.new do |opts|
      opts.banner = "Usage: glibrary [options...] [query]"
      @library = library = opts.default_argv.include?("-l")

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
        handle_nonexistent_file(filename, library) unless File.exist?(filename)
      end

      opts.on("-l", "--library", "See your library; ignores all search options") do
        prepare_filename_for_os!(filename)
        unless suppress
          (l = UserLibrary.new(filename: filename)).pretty_print
          library_mode_user_prompt(l) 
          exit
        end
      end

      opts.on("-h", "--help", "Prints this help") do
        print_help_message(opts)
        exit
      end

    end.parse!
    return [(@filename = filename), o]
  end
end
