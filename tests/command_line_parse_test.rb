require 'test/unit'
require_relative '../modules/errors/'
require_relative '../modules/command_line_parse'

class CommandLineParseTest < Test::Unit::TestCase
  include CommandLineParse
  include Errors

  def setup
    ARGV.each_index do |i|
      ARGV.delete_at(i)
    end
    @options = {}
    
  end

    #_, _ = command_line_parse!("/tmp/test.json", {})

  def test_command_line_parse_search_mode_no_flags
    ARGV << "harry" 
    ARGV << "potter"
    command_line_parse!
    assert @options.size > 0
  end

  def test_command_line_parse_search_mode_with_flags
    %w[-t potter -a rowling -p blablabla].each do |s|
      ARGV << s
    end
    command_line_parse!
    assert @options[:title] == "potter" &&
      @options[:author] == "rowling" &&
      @options[:publisher] == "blablabla"
  end

  def test_command_line_parse_search_mode_with_alternative_flags
    %w[--title potter --author rowling --publisher blablabla].each do |s|
      ARGV << s
    end
    command_line_parse!
    assert @options[:title] == "potter" &&
      @options[:author] == "rowling" &&
      @options[:publisher] == "blablabla"
  end

  def test_command_line_parse_library_mode
    %w[-t hello -f /tmp/test.json -l].each { |s| ARGV << s }
    command_line_parse!
    assert @options.nil?
  end

  def test_command_line_parse_filename_caught
    %w[-t hello -f /tmp/test.json -l].each { |s| ARGV << s }
    command_line_parse!
    assert_equal @filename, "/tmp/test.json"
  end

end
