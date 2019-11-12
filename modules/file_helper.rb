#assumes a @filename instance variable in the including class.
require_relative 'errors'

module FileHelper

  def prepare_for_os(filename)
    ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i } ? 
      filename.gsub(/\//, '\\') : filename 
  end

  def prepare(filename)
    filename = File.absolute_path(filename)
    prepare_for_os(filename)
  end

end
