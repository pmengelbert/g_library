require 'test/unit'
require_relative '../exec_helpers/exec_helper.rb'
require_relative '../globals/errors'
require_relative '../lib/book_search.rb'

class TestExecHelper < Test::Unit::TestCase
  
  

  def test_process_args_method
    args = %w[harry potter -l -f /tmp/library.json]
    process_args! args
    assert args[-1] == "-l"
  end

end
