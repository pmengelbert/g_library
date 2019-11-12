require_relative 'errors'

module FileHelper
  def self.prepare_for_os(filename)
    ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i } ? 
      filename.gsub(/\//, '\\') : filename 
  end

  def self.prepare(filename)
    filename = File.absolute_path(filename)
    FileHelper.prepare_for_os(filename)
  end

end
