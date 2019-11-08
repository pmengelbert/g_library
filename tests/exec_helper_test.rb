require 'test/unit'
require_relative '../common/exec_helper.rb'

class Test::Unit::TestCase

  def test_process_args_method
    args = %w[harry potter -l -f /tmp/library.json]
    process_args! args
    assert args[-1] == "-l"
  end

end
