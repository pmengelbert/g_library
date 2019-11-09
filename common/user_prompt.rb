def handle_user_input(selection)
  raise SelectionError unless selection =~ /\A[1-5]|[qQ]\Z/
  raise UserQuits if selection =~ /\A[Qq]\Z/
  selection = selection.to_i
  return selection - 1
end

def get_book_number
  print "Enter a number (1-5) to add a book to your reading list (or q to quit): "
  selection = STDIN.gets.strip
  i = handle_user_input(selection)
  return i
end

def handle_successful_prompt_completion(selected_book)
  puts "The book \"#{selected_book['title']}\" has been added to your reading list."
end

def exec_user_prompt(temp_booklist, persistent_library)
  while true
    begin

      i = get_book_number
      selected_book = temp_booklist[i]

      persistent_library << selected_book
      persistent_library.save

      handle_successful_prompt_completion(selected_book)
      break

    rescue SelectionError
      puts "\nSorry, your selection was invalid.  Please try again."
    rescue DataError
      puts "\nSorry, your selection was invalid.  Make sure your selection is within the range of available options."
    end
  end
end
