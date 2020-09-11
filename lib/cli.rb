class Cli
  attr_reader :zipcode, :type, :search
  #---------------------------------------------login----------------------------------------#
  #initializes a new CLI instance and starts the welcome and prompt.
  def initialize
    font = TTY::Font.new(:starwars)
    system "clear"
    puts Pastel.new.cyan(font.write("BestByMe"))
    puts Pastel.new.magenta("----------------------------------------------------------------------------------------")
    puts Pastel.new.cyan("Welcome to BestByMe, the best resource for top-rated businesses in your area!")

    self.login_prompt
  end

  #Sends the user to the login screen, once authorized sends them to the main menu.
  def login_prompt
    @user = self.create_new_account_or_login
    self.main_menu
  end

  #Prompts user to either login or create a new account.
  def create_new_account_or_login
    prompt = TTY::Prompt.new
    prompt.select("Would you like to create a new account or sign in to an existing account?") do |menu|
      #calls the appropriate method based on user input.
      menu.choice "sign in to an existing account", -> { self.sign_into_existing_account }
      menu.choice "create a new account", -> { self.create_new_user_account }
    end
  end

  #Walks user through the process of creating a new account.
  def create_new_user_account
    puts "Please enter your username"
    user_username_input = gets.chomp
    user = User.find_by(username: user_username_input)

    if user == nil
      puts Pastel.new.cyan("Your username has been saved. Please enter your first name.")
      user_name = gets.chomp
      password = TTY::Prompt.new
      user_password = password.mask("Please enter your password.")
      system "clear"
      puts Pastel.new.cyan.bold("You're all set up #{user_name.capitalize}! Your username is #{user_username_input}.")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      user = User.create(name: user_name, username: user_username_input, password: user_password)
    else
      puts Pastel.new.red("Sorry that username is already taken.")
      self.create_new_user_account
    end
    user
  end

  #Guides user through the login process.
  def sign_into_existing_account
    puts Pastel.new.cyan("Please enter your username.")
    user_username = gets.chomp
    password = TTY::Prompt.new
    user_password = password.mask("Please enter your password.")
    user = User.find_by(username: user_username, password: user_password)
    system "clear"
    #Checks to see whether a matching username can be found.
    #If a match is found, the user is logged in and greeted by name.
    # If no match is found, the user to is instructed to re-enter the information.
    if user == nil
      puts Pastel.new.red("There is no user found with that username and password. Please try again.")
      self.create_new_account_or_login
    else
      user = User.find_by(username: user_username, password: user_password)
      puts Pastel.new.cyan.bold("Hello #{user.name}!")
      puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    end
    user
  end

  def main_menu
    font = TTY::Font.new(:doom)
    puts Pastel.new.cyan(font.write("MAIN MENU"))
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    prompt = TTY::Prompt.new
    prompt.select("What would you like to do?") do |menu|
      #calls the appropriate method based on user input.
      menu.choice "Search for a business", -> {
                    system "clear"
                    self.search_prompt
                  }
      menu.choice "View my wishlist", -> {
                    system "clear"
                    self.display_wishlist(User.user_wishlist(@user.id))
                  }
      menu.choice "View my check-ins", -> { self.display_checkins(User.user_checkins(@user.id)) }
      menu.choice "Most visited businesses", -> {
                    system "clear"
                    self.ten_most_checked
                  }
      menu.choice "Logout of BestByMe", -> { Cli.new }
    end
  end

  #---------------------------------business search--------------------------------#
  #Prompts the user to enter a zip code and business search term so the data can be fetched.
  def search_prompt
    font = TTY::Font.new(:doom)
    puts Pastel.new.cyan(font.write("SEARCH"))
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    puts Pastel.new.cyan("To get started, please enter the zip code for your business search!")
    @zipcode = gets.chomp

    puts Pastel.new.cyan("Next, please enter the type of business you're looking for!")
    @type = gets.chomp

    @search = GetBusinesses.search(term: @type, location: @zipcode)

    if (@search.keys.include?("businesses") && @search["businesses"].length > 0) == false
      system "clear"
      puts Pastel.new.red("Invalid search. Please try again!")
      puts Pastel.new.magenta("---------------------------------------------------------------------------")
      self.search_prompt
    else
      system "clear"
      self.show_top_ten
    end
  end

  #Displays top 10 highest rated businesses based on the user's search
  def show_top_ten
    font = TTY::Font.new("3d")
    puts Pastel.new.cyan(font.write("TOP10"))
    #prints out list of top 10 businesses, prompts the user to learn more about a business.
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    puts Pastel.new.cyan("1. #{@search["businesses"][0]["name"]} - #{@search["businesses"][0]["price"]}")
    puts Pastel.new.cyan("2. #{@search["businesses"][1]["name"]} - #{@search["businesses"][1]["price"]}")
    puts Pastel.new.cyan("3. #{@search["businesses"][2]["name"]} - #{@search["businesses"][2]["price"]}")
    puts Pastel.new.cyan("4. #{@search["businesses"][3]["name"]} - #{@search["businesses"][3]["price"]}")
    puts Pastel.new.cyan("5. #{@search["businesses"][4]["name"]} - #{@search["businesses"][4]["price"]}")
    puts Pastel.new.cyan("6. #{@search["businesses"][5]["name"]} - #{@search["businesses"][5]["price"]}")
    puts Pastel.new.cyan("7. #{@search["businesses"][6]["name"]} - #{@search["businesses"][6]["price"]}")
    puts Pastel.new.cyan("8. #{@search["businesses"][7]["name"]} - #{@search["businesses"][7]["price"]}")
    puts Pastel.new.cyan("9. #{@search["businesses"][8]["name"]} - #{@search["businesses"][8]["price"]}")
    puts Pastel.new.cyan("10. #{@search["businesses"][9]["name"]} - #{@search["businesses"][9]["price"]}")
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    puts Pastel.new.green("To learn more about a business, enter the number to the left of it or enter 'M' to return to the main menu.")

    @list_number = gets.chomp
    if @list_number == "m" || @list_number == "M"
      system "clear"
      self.main_menu
    elsif (1..10).include?(@list_number.to_i) == false
      system "clear"
      puts Pastel.new.red("Invalid entry. Please try again.")
      puts Pastel.new.magenta("---------------------------------------------------------------------------")
      self.show_top_ten
    else
      self.learn_more(@list_number)
    end
  end

  #Allows the user to enter number of business they wish to learn more about.
  def learn_more(number)
    system "clear"
    directory = @search["businesses"][(number.to_i - 1)]

    #Business_detail_variables
    @bname = directory["name"]
    @baddress = (directory["location"]["display_address"]).join(" ")
    @bphone = directory["display_phone"]
    @brating = directory["rating"]
    @bprice = directory["price"]
    @blink = directory["url"]

    #Prints out the businesses details, prompts the user to add that to their wishlist
    puts Pastel.new.cyan("Name: #{@bname}")
    puts Pastel.new.cyan("Address: #{@baddress}")
    puts Pastel.new.cyan("Phone: #{@bphone}")
    puts Pastel.new.cyan("Rating: #{@brating}")
    puts Pastel.new.cyan("Price:#{@bprice}")
    puts Pastel.new.cyan("Yelp Link: #{@blink}")
    puts Pastel.new.magenta("----------------------------------------------------------------------------")
    puts Pastel.new.green("A wishlist is a place where you can save all of the businesses that you would like to visit. Would you like to add this business to your wishlist? (Y/N)")

    yes_or_no = gets.chomp
    self.add_to_wishlist(yes_or_no)
  end

  #-----------------------------------------------wishlist---------------------------------------------------#
  #Allows user to add a business to their wishlist, or returns them to the top 10 list
  def add_to_wishlist(yes_or_no)
    exist = Business.where("name = ? and address = ?", @bname, @baddress)
    case yes_or_no
    when "y"
      if exist.length == 0
        new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
        Wishlist.create(business_id: new_business.id, user_id: @user.id)
      else
        Wishlist.create(business_id: (exist[0]).id, user_id: @user.id)
      end
      system "clear"
      puts Pastel.new.green.bold("This business has been added to your wishlist! Feel free to add another.")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.show_top_ten
    when "Y"
      if exist.length == 0
        new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
        Wishlist.create(business_id: new_business.id, user_id: @user.id)
      else
        Wishlist.create(business_id: (exist[0]).id, user_id: @user.id)
      end
      system "clear"
      puts Pastel.new.cyan.bold("This business has been added to your wishlist! Feel free to add another.")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.show_top_ten
    when "n"
      system "clear"
      self.show_top_ten
    when "N"
      system "clear"
      self.show_top_ten
    else
      puts Pastel.new.red("Invalid entry, please enter Y or N")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.learn_more(@list_number)
    end
  end

  def display_wishlist(wish_bus)
    font = TTY::Font.new(:doom)
    puts Pastel.new.cyan(font.write("WISHLIST"))
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    if wish_bus.length == 0
      system "clear"
      puts Pastel.new.red("Your wishlist is currently empty. Search for a business to add one!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.main_menu
    else
      @wish_bus = wish_bus
      counter = 0
      @wish_bus.each do |business|
        puts Pastel.new.cyan("#{(counter + 1)}. #{business.name} - #{business.price_range}")
        counter += 1
      end
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      puts Pastel.new.green("To view additional information or check-in at a business: Enter the number to the left of the business or enter 'M' to return the main menu.")
      @input = gets.chomp
      if @input == "m" || @input == "M"
        system "clear"
        self.main_menu
      elsif (1..(@wish_bus.length)).include?(@input.to_i) == false
        system "clear"
        puts Pastel.new.red("Invalid entry. Please try again.")
        puts Pastel.new.magenta("---------------------------------------------------------------------------")
        self.display_wishlist(@wish_bus)
      else
        self.display_details(@input)
      end
    end
  end

  def display_details(input)
    system "clear"
    selection = @wish_bus[(input.to_i - 1)]

    #Business_detail_variables
    @bname2 = selection.name
    @baddress2 = selection.address
    @bphone2 = selection.phone_number
    @brating2 = selection.rating
    @bprice2 = selection.price_range
    @blink2 = selection.yelp_link
    @bid2 = selection.id

    #Prints out the businesses details, prompts the user to add that to their wishlist
    puts Pastel.new.cyan("Name: #{@bname2}")
    puts Pastel.new.cyan("Address: #{@baddress2}")
    puts Pastel.new.cyan("Phone: #{@bphone2}")
    puts Pastel.new.cyan("Rating: #{@brating2}")
    puts Pastel.new.cyan("Price:#{@bprice2}")
    puts Pastel.new.cyan("Yelp Link: #{@blink2}")
    puts Pastel.new.magenta("----------------------------------------------------------------------------")
    puts Pastel.new.green("If you would like to check-in to this business, enter 'C'. To remove this business, enter 'R'. To return to your wishlist, enter 'W'. (C/R/W)")

    answer = gets.chomp
    self.user_checkin(answer)
  end

  #--------------------------------------------checkins-----------------------------------------#

  def user_checkin(answer)
    case answer
    when "c"
      Checkin.create(business_id: @bid2, user_id: @user.id)
      remove = Wishlist.where("user_id == ? and business_id ==?", @user.id, @bid2)
      Wishlist.destroy(remove.first.id)
      system "clear"
      puts Pastel.new.cyan.bold("You have successfully checked into this business!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.display_wishlist(User.user_wishlist(@user.id))
    when "C"
      Checkin.create(business_id: @bid2, user_id: @user.id)
      remove = Wishlist.where("user_id == ? and business_id ==?", @user.id, @bid2)
      Wishlist.destroy(remove.first.id)
      system "clear"
      puts Pastel.new.cyan.bold("You have successfully checked into this business!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.display_wishlist(User.user_wishlist(@user.id))
    when "w"
      system "clear"
      self.display_wishlist(@wish_bus)
    when "W"
      system "clear"
      self.display_wishlist(@wish_bus)
    when "r"
      remove = Wishlist.where("user_id == ? and business_id ==?", @user.id, @bid2)
      Wishlist.destroy(remove.first.id)
      system "clear"
      puts Pastel.new.cyan.bold("You have successfully removed this business from your wishlist!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.display_wishlist(User.user_wishlist(@user.id))
    when "R"
      remove = Wishlist.where("user_id == ? and business_id ==?", @user.id, @bid2)
      Wishlist.destroy(remove.first.id)
      system "clear"
      puts Pastel.new.cyan.bold("You have successfully removed this business from your wishlist!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.display_wishlist(User.user_wishlist(@user.id))
    else
      puts Pastel.new.red("Invalid entry. If you would like to check-in to this business, enter 'C'. To remove this business, enter 'R'. To return to your wishlist, enter 'W'. (C/R/W)")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.display_details(@input)
    end
  end

  def display_checkins(check_bus)
    if check_bus.length == 0
      system "clear"
      puts Pastel.new.red("You don't have any check-ins to display yet!")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.main_menu
    else
      system "clear"
      font = TTY::Font.new(:doom)
      puts Pastel.new.cyan(font.write("CHECK-INS"))
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      @check_bus = check_bus
      counter = 0
      @check_bus.each do |business|
        puts Pastel.new.cyan("#{(counter + 1)}. #{business.name} - #{business.price_range}")
        counter += 1
      end
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      puts Pastel.new.green("Enter 'M' to return to main menu.")
      input = gets
      system "clear"
      self.main_menu
    end
  end

  #---------------------------------------top 10 check-ins list-----------------------------------------#
  def ten_most_checked
    font = TTY::Font.new("3d")
    puts Pastel.new.cyan(font.write("TOP10"))

    business_name = Checkin.get_business_name
    check_ins = Checkin.get_num_checkins

    puts Pastel.new.cyan.bold("Check out our top 10 most checked in places!")
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    puts Pastel.new.cyan("1. #{business_name[0]} - #{check_ins[0]} total check-ins")
    puts Pastel.new.cyan("2. #{business_name[1]} - #{check_ins[1]} total check-ins")
    puts Pastel.new.cyan("3. #{business_name[2]} - #{check_ins[2]} total check-ins")
    puts Pastel.new.cyan("4. #{business_name[3]} - #{check_ins[3]} total check-ins")
    puts Pastel.new.cyan("5. #{business_name[4]} - #{check_ins[4]} total check-ins")
    puts Pastel.new.cyan("6. #{business_name[5]} - #{check_ins[5]} total check-ins")
    puts Pastel.new.cyan("7. #{business_name[6]} - #{check_ins[6]} total check-ins")
    puts Pastel.new.cyan("8. #{business_name[7]} - #{check_ins[7]} total check-ins")
    puts Pastel.new.cyan("9. #{business_name[8]} - #{check_ins[8]} total check-ins")
    puts Pastel.new.cyan("10. #{business_name[9]} - #{check_ins[9]} total check-ins")
    puts Pastel.new.magenta("-----------------------------------------------------------------------------")
    puts Pastel.new.green("To learn more about a business, enter the number to the left of it or enter 'M' to return to the main menu.")

    @check_number = gets.chomp
    if @check_number == "m" || @check_number == "M"
      system "clear"
      self.main_menu
    elsif (1..10).include?(@check_number.to_i) == false
      system "clear"
      puts Pastel.new.red("Invalid entry. Please try again.")
      puts Pastel.new.magenta("---------------------------------------------------------------------------")
      self.ten_most_checked
    else
      self.research_top_ten(@check_number)
    end
  end

  def research_top_ten(number)
    system "clear"

    array_number = ((number.to_i) - 1)
    current_list = Checkin.get_businesses

    #Business_detail_variables
    @bname3 = current_list[array_number].name
    @baddress3 = current_list[array_number].address
    @bphone3 = current_list[array_number].phone_number
    @brating3 = current_list[array_number].rating
    @bprice3 = current_list[array_number].price_range
    @blink3 = current_list[array_number].yelp_link
    @bid3 = current_list[array_number].id

    users_array = Checkin.get_users(@bid3)
    counter = 0

    #Prints out the businesses details, prompts the user to add that to their wishlist
    puts Pastel.new.cyan("Name: #{@bname3}")
    puts Pastel.new.cyan("Address: #{@baddress3}")
    puts Pastel.new.cyan("Phone: #{@bphone3}")
    puts Pastel.new.cyan("Rating: #{@brating3}")
    puts Pastel.new.cyan("Price:#{@bprice3}")
    puts Pastel.new.cyan("Yelp Link: #{@blink3}")
    puts Pastel.new.magenta("----------------------------------------------------------------------------")
    puts Pastel.new.cyan("Users that have checked in here:")
    users_array.each do |user|
      puts "#{user}"
      counter += 1
    end
    puts Pastel.new.magenta("----------------------------------------------------------------------------")
    puts Pastel.new.green("A wishlist is a place where you can save all of the businesses that you would like to visit. Would you like to add this business to your wishlist? (Y/N)")

    yes_or_no = gets.chomp
    self.add_to_wishlist_from_top_ten(yes_or_no)
  end

  def add_to_wishlist_from_top_ten(yes_or_no)
    case yes_or_no
    when "y"
      Wishlist.create(business_id: @bid3, user_id: @user.id)
      system "clear"
      puts Pastel.new.cyan.bold("This business has been added to your wishlist! Feel free to add another.")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.ten_most_checked
    when "Y"
      Wishlist.create(business_id: @bid3, user_id: @user.id)
      system "clear"
      puts Pastel.new.cyan.bold("This business has been added to your wishlist! Feel free to add another.")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.ten_most_checked
    when "n"
      system "clear"
      self.ten_most_checked
    when "N"
      system "clear"
      self.ten_most_checked
    else
      puts Pastel.new.red("Invalid entry, please enter Y or N")
      puts Pastel.new.magenta("----------------------------------------------------------------------------")
      self.research_top_ten(@check_number)
    end
  end
end
