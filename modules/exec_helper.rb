module ExecHelper

  def process_args!(args = ARGV)
    args << '-h' if args.empty?
    args << args.delete("-l") if args.include?("-l")
  end

  def library_mode?
    @options.nil?
  end

end
