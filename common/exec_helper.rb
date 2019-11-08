def process_args!
  ARGV << '-h' if ARGV.empty?
  ARGV << ARGV.delete("-l") if ARGV.include?("-l")
end

def prepare_filename_for_os!(filename)
  filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
end

