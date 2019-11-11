require 'test/unit'
require_relative '../common/user_prompt'
require_relative '../common/errors'

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

end

