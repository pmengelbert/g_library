require_relative 'errors'

module ExecHelper
  include Errors

  def process_args!(args = ARGV)
    args << '-h' if args.empty?
    args << args.delete("-l") if args.include?("-l")
  end

  def library_mode?
    @options.nil?
  end

  def perform_search
    search = @options[:search] || ARGV.join('+')
    s = BookSearch.new(search: search, title: @options[:title], author: @options[:author], 
                       publisher: @options[:publisher])
  end
end
