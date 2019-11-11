require 'test/unit'
require_relative '../common/user_prompt'
require_relative '../common/errors'
require_relative '../classes/user_library'
require_relative '../classes/book_search'

class TestUserPrompt < Test::Unit::TestCase
  include UserPrompt
  include Errors

  def setup
    @smr = /\A[1-5]|[qQ]\Z/
    @lmr = /\A([0-9]+|[qQ])\Z/
  end 

  def test_verify_selection_user_quits
    assert_raise( UserQuits ) { verify_selection("q", /./) }
    assert_raise( UserQuits ) { verify_selection("Q", /./) }
  end

  def test_verify_selection_bad_input
    assert_raise( SelectionError ) { verify_selection("7", @smr) }
    assert_raise( SelectionError ) { verify_selection("y", @smr) }
    assert_raise( SelectionError ) { verify_selection("we2y", @smr) }
    assert_raise( SelectionError ) { verify_selection("weqy", @smr) }
    assert_raise( SelectionError ) { verify_selection("", @smr) }
  end

  def test_verify_selection_good_input
    assert_nothing_raised( Exception ) { verify_selection("2", @smr) }
    assert_nothing_raised( Exception ) { verify_selection("1", @smr) }
  end

  def test_process_selection
    assert_equal 3, process_selection("4")
  end

  def test_search_prompt_with_valid_selection
    l = UserLibrary.new(nonpersistent: true)
    s = BookSearch.new(search: "harry potter")
    s.each { |info| l.add UserBook.new(info) }
    assert_nothing_raised( Exception ) { prompt("", @smr, l, "3") }
  end

  def test_library_prompt_with_invalid_selection
    l = UserLibrary.new(nonpersistent: true)
    s = BookSearch.new(search: "harry potter")
    s.each { |info| l.add UserBook.new(info) }
    assert_raise ( NotABook  ) { prompt("", @lmr, l, "7") }
  end

end

