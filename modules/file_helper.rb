require_relative 'errors'

module FileHelper

  CURRENT_DIR = File.join(File.dirname(__FILE__))

  DEFAULT_FILENAME =  File.join( File.expand_path("..", CURRENT_DIR), 
    "saved_libraries", "library.json" )

  def self.prepare_for_os(filename)
    ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i } ? 
      filename.gsub(/\//, '\\') : filename 
  end

  def self.prepare(filename)
    filename = File.absolute_path(filename)
    FileHelper.prepare_for_os(filename)
  end

end
