require_relative '../globals/errors'

def verify_selection(selection, regexp)
  raise SelectionError unless selection =~ regexp
  raise UserQuits if selection =~ /\A[Qq]\Z/
end

def process_selection(selection)
  return selection.to_i - 1
end

def handle_successful_prompt_completion(selected_book)
  puts ""
  puts "The book \"#{selected_book['title']}\" has been added to your reading list."
end

def prompt(prompt, regexp, library, suppress = nil)
  print prompt
  s = suppress || STDIN.gets.strip
  verify_selection(s, regexp)
  s = process_selection(s)
  raise NotABook unless s <= library.size
  return s
end

def library_mode_user_prompt(lib)
  while true
    begin
      lib.pretty_print

      i = prompt( "Select a book number to delete, or type \"q\" to quit: ", /\A([0-9]+|[qQ])\Z/,
             lib)

      lib.delete(i)
      lib.save

      puts "Your library now looks like this."
      puts ""
    rescue SelectionError
      puts "\nSorry, your selection was invalid. Please try again."
    rescue NotABook
      puts "\nSorry, your selection was invalid. Make sure your selection is in the provided range."
    end
  end
end


def search_mode_user_prompt(temp_booklist, persistent_library)

  temp_booklist.pretty_print

  while true
    begin

      i = prompt( "Enter a number (1-5) to add a book to your reading list (or q to quit): ",
              /\A[1-5]|[qQ]\Z/, temp_booklist )
      selected_book = temp_booklist[i]

      persistent_library << selected_book
      persistent_library.save

      handle_successful_prompt_completion(selected_book)
      puts "Would you like to add another?"
      puts ""
    rescue BookDuplicateError
      puts "\nThat book is already in your reading list.  Would you like to add another?"
      puts ""
    rescue SelectionError
      puts "\nSorry, your selection was invalid.  Please try again."
      puts ""
    rescue NotABook
      puts "\nSorry, your selection was invalid.  Make sure your selection is within the range of available options."
      puts ""
    end
  end

end

