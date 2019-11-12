require 'test/unit'
require_relative '../modules/exec_helper.rb'
require_relative '../modules/errors'
require_relative '../lib/book_search.rb'

class TestExecHelper < Test::Unit::TestCase
  include ExecHelper
  

  def test_process_args_method
    args = %w[harry potter -l -f /tmp/library.json]
    process_args! args
    assert args[-1] == "-l"
  end

end
