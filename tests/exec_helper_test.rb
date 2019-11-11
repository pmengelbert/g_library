require 'test/unit'
require_relative '../common/exec_helper.rb'
require_relative '../common/errors'
require_relative '../classes/book_search.rb'

class TestExecHelper < Test::Unit::TestCase
  include ExecHelper
  include Errors

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

  #assumes internet connection
  def test_perform_search_with_successful_search
    assert !perform_search(search: "harry potter", title: "azkaban", author: "rowling").nil?
  end

  def test_perform_search_with_bad_search
    assert_raise( NoResults ) { perform_search(search: "2039iodwioujoi\\erw4093") }
  end

end
