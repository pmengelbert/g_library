def process_args!(args = ARGV)
  args << '-h' if args.empty?
  args << args.delete("-l") if args.include?("-l")
end

def prepare_filename_for_os!(filename)
  filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
end

