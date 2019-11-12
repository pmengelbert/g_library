require_relative '../globals/errors'

def with_library_mode_error_handling
  begin
    yield
  rescue UserQuits
    puts "\nEnjoy your day."
  rescue Errno::EACCES
    puts "\nYou don't have permission to write to the file you specified.  Quitting immediately"
    puts ""
  end
  exit
end
  
def with_search_mode_error_handling
  begin 
    yield
  rescue UserQuits
    puts "\nThanks for browsing. Library file saved"
    puts ""
  rescue Errno::EACCES
    puts "\nYou don't have permission to write to the file you specified.  Quitting immediately"
    puts ""
  rescue NoInternetError
    puts "\nNo internet connection.  Please connect to the internet and try again."
    puts ""
  rescue SearchError 
    puts "\nThere was an error with your query; be careful to format it well"
    puts ""
  rescue NoResults
    puts "\nNo results."
    puts ""
  end
  exit
end
