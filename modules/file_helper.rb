require_relative 'errors'

module FileHelper

  def prepare_filename_for_os!
    @filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
  end

end
