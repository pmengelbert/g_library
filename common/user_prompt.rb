module UserPrompt
  def verify_selection(selection, regexp)
    raise SelectionError unless selection =~ regexp
    raise UserQuits if selection =~ /\A[Qq]\Z/
  end

  def process_selection(selection)
    return selection.to_i - 1
  end

  def handle_successful_prompt_completion(selected_book)
    puts "The book \"#{selected_book['title']}\" has been added to your reading list."
    puts ""
  end

  def prompt(prompt, regexp, library)
    print prompt
    s = STDIN.gets.strip
    verify_selection(s, regexp)
    s = process_selection(s)
    raise DataError unless s <= library.size
    return s
  end

  def library_mode_user_prompt(library)
    while true
      begin
        i = prompt( "Select a book number to delete, or type \"q\" to quit: ", /\A([0-9]+|[qQ])\Z/,
               library )

        library.delete(i)
        library.pretty_print

        puts "Your library now looks like this."
        puts ""
      rescue SelectionError
        puts "\nSorry, your selection was invalid. Please try again."
      rescue DataError
        puts "\nSorry, your selection was invalid. Make sure your selection is in the provided range."
      rescue UserQuits
        library.save
        puts "\nEnjoy your day."
        exit
      end
    end
  end


  def search_user_prompt(temp_booklist, persistent_library)
    while true
      begin

        i = prompt( "Enter a number (1-5) to add a book to your reading list (or q to quit): ",
                /\A[1-5]|[qQ]\Z/, temp_booklist )
        selected_book = temp_booklist[i]

        persistent_library << selected_book
        persistent_library.save

        handle_successful_prompt_completion(selected_book)
        puts "Would you like to add another?"
      rescue BookDuplicateError
        puts "\nThat book is already in your reading list.  Would you like to add another?"
      rescue SelectionError
        puts "\nSorry, your selection was invalid.  Please try again."
      rescue DataError
        puts "\nSorry, your selection was invalid.  Make sure your selection is within the range of available options."
      end
    end
  end
end
