require 'test/unit'
require_relative '../modules/file_helper.rb'
require_relative '../modules/errors'

class TestFileHelper < Test::Unit::TestCase
  
  

  def test_method_prepare
    filename = "/home/pme/"
    ENV["test"] = "C:\\Windows"
    filename = FileHelper.prepare(filename)
    assert filename =~ /\\/
    ENV.delete("test")
  end

end
