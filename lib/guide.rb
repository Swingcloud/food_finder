require 'restaurant'

class Guide 

  class Config
    @@actions = ["list", "find", "add", "quit"]
    def self.actions ; @@actions ; end
  end

	def initialize(path=nil)
		# locate the restaurant text file at path
    Restaurant.filepath = path
    if Restaurant.file_usable?
      puts "Found restaurant file."
		# or create a new file 
    elsif Restaurant.create_file
      puts "Create restaurant file."
		# exit if create fails
    else
      puts "Exiting. \n\n"
      exit!
    end

	end

	def launch!
		introduction
    # action loop
    result = nil
    until result == :quit 
      action = get_action     
      result = do_action(action)
    end
    conclusion

	end

  def get_action
    action = nil
    # Keep askingfor user input until we get the valid action
    until Guide::Config.actions.include?(action)
      puts "Actions: "+Guide::Config.actions.join(", ") if action
      print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    return action
  end

  def do_action(action)
    case action 
    when "list"
      list
    when "find"
      puts "Finding..."
    when "add"
      add
    when "quit"
      return :quit
    else
      puts "\n I don't understand that command. \n"
    end    
  end

  def list
    puts "\nListing restaurants".upcase
    restaurants = Restaurant.saved_restaurants
    restaurants.each do |restaurant|
      puts restaurant.name + " | " + restaurant.cuisine + " | " + restaurant.price 
    end

  end

  def add
    puts "\n\n Add a restaurant".upcase
    
    restaurant = Restaurant.build_using_questions

    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: Restaurant not Added \n\n"
    end
  end

  def introduction
    puts "\n\n <<< Welcome to the Food Finder >>> \n\n"
    puts "This is an interactive guide to help you find the food you crave. \n\n"
  end

  def conclusion
    puts "\n <<< Goodbye and Bon Appetit! >>> \n\n\n"

  end

end