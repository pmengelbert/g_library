require 'test/unit'
require_relative '../common/exec_helper.rb'

class TestExecHelper < Test::Unit::TestCase

  def test_process_args_method
    args = %w[harry potter -l -f /tmp/library.json]
    process_args! args
    assert args[-1] == "-l"
  end

  def test_method_prepare_filename_for_os!
    s = "/home/pme/"
    ENV["test"] = "C:\\Windows"
    prepare_filename_for_os!(s)
    ENV.delete("test")
    assert s=~ /\\/
  end

end
