require 'test/unit'
require_relative '../common/errors/'
require_relative '../common/command_line_parse'

class CommandLineParseTest < Test::Unit::TestCase
  include CommandLineParse
  include Errors

  def setup
    ARGV.each_index do |i|
      ARGV.delete_at(i)
    end
    
  end

    #_, _ = command_line_parse!("/tmp/test.json", {})

  def test_command_line_parse_search_mode_no_flags
    ARGV << "harry" 
    ARGV << "potter"
    _, _ = command_line_parse!("/tmp/test.json", {}, true)
    assert ARGV == ["harry", "potter"]
  end

  def test_command_line_parse_search_mode_with_flags
    %w[-t potter -a rowling -p blablabla].each do |s|
      ARGV << s
    end
    _, o = command_line_parse!("/tmp/test.json", {}, true)
    assert o[:title] == "potter" &&
      o[:author] == "rowling" &&
      o[:publisher] == "blablabla"
  end

  def test_command_line_parse_search_mode_with_alternative_flags
    %w[--title potter --author rowling --publisher blablabla].each do |s|
      ARGV << s
    end
    _, o = command_line_parse!("/tmp/test.json", {}, true)
    assert o[:title] == "potter" &&
      o[:author] == "rowling" &&
      o[:publisher] == "blablabla"
  end

  def test_command_line_parse_library_mode
    %w[-t hello -f /tmp/test.json -l].each { |s| ARGV << s }
    _, _ = command_line_parse!("/tmp/test.json", {}, true)
    assert @library
  end

  def test_command_line_parse_filename_caught
    %w[-t hello -f /tmp/test.json -l].each { |s| ARGV << s }
    _, _ = command_line_parse!("/tmp/test.json", {}, true)
    assert_equal @filename, "/tmp/test.json"
  end

end
