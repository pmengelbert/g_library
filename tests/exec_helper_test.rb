require 'test/unit'
require_relative '../modules/exec_helper.rb'
require_relative '../modules/errors'
require_relative '../lib/book_search.rb'

class TestExecHelper < Test::Unit::TestCase
  include ExecHelper
  include Errors

  def test_process_args_method
    args = %w[harry potter -l -f /tmp/library.json]
    process_args! args
    assert args[-1] == "-l"
  end

  #assumes internet connection
  def test_perform_search_with_successful_search
    @options = { search: "harry potter", title: "azkaban", author: "rowling" }
    assert !perform_search.nil?
  end

  def test_perform_search_with_bad_search
    @options = { search: "2039iodwioujoi\\erw4093" }
    assert_raise( NoResults ) { perform_search }
  end

end
