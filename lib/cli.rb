class Cli

    attr_reader :zipcode, :type, :search
#---------------------------------------------login----------------------------------------#
    #initializes a new CLI instance and starts the welcome and prompt.
    def initialize
        system "clear"
        puts 'Welcome to BestByMe, the best resource for top-rated businesses in your area!'
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
        menu.choice 'sign in to an existing account', -> {self.sign_into_existing_account}
        menu.choice "create a new account", -> {self.create_new_user_account}
        end
    end

    #Walks user through the process of creating a new account. 
    def create_new_user_account
        puts "\n\e[95mPlease enter your username\e[0m"
        user_username_input = gets.chomp 
        user = User.find_by(username: user_username_input) 
        
        if user == nil
            puts "\e[95mYour username has been saved. Please enter your first name.\e[0m"
            user_name = gets.chomp
            password = TTY::Prompt.new
            user_password = password.mask("\e[95mPlease enter your password.\e[0m")
            system "clear"
            puts "\n\e[93m You're all set up #{user_name.capitalize}! Your username is #{user_username_input}.\e[0m"
            puts "----------------------------------------------------------------------------"
            user =  User.create(name:user_name, username: user_username_input, password: user_password)
        else
            puts "\n\e[91mSorry that username is already taken.\e[0m"
            self.create_new_user_account
        end
    user
end

    #Guides user through the login process.
    def sign_into_existing_account
        puts"\n\e[95mPlease enter your username.\e[0m"
        user_username = gets.chomp
        password = TTY::Prompt.new
        user_password = password.mask("\e[95mPlease enter your password.\e[0m")
        user = User.find_by(username: user_username, password: user_password)
        system "clear"
        #Checks to see whether a matching username can be found.
        #If a match is found, the user is logged in and greeted by name.
        # If no match is found, the user to is instructed to re-enter the information. 
        if user == nil
        puts "\n\e[91mThere is no user found with that username and password. Please try again.\e[0m"
            self.create_new_account_or_login
        else
            user = User.find_by(username: user_username, password: user_password)
            puts "\n\e[93mHello #{user.name}!"
        
        end
    user
    end

    def main_menu 
        prompt = TTY::Prompt.new
        prompt.select("What would you like to do?") do |menu|
        #calls the appropriate method based on user input.
        menu.choice 'Search for a business', -> {
            system "clear"
            self.search_prompt}
        menu.choice 'View my wishlist', -> {
            system "clear"
            self.display_wishlist(User.user_wishlist(@user.id))
        }
        menu.choice 'View my checkins', -> {self.display_checkins(User.user_checkins(@user.id))}
        menu.choice 'Most visited businesses', -> {
            system "clear"
            self.ten_most_checked}
        menu.choice 'Logout of BestByMe', -> {Cli.new}
        end
    end
#---------------------------------business search--------------------------------#
    #Prompts the user to enter a zip code and business search term so the data can be fetched.
    def search_prompt
        puts "To get started, please enter the zip code for your business search!"
        @zipcode = gets.chomp

        puts "Next, please enter the type of business you're looking for!"
        @type = gets.chomp

        @search = GetBusinesses.search(term: @type,location: @zipcode)
        
        if (@search.keys.include?("businesses") && @search["businesses"].length > 0) == false 
            system "clear"
            puts "Invalid search. Please try again!"
            puts "-----------------------------------------------------------------------------"
            self.search_prompt
        else
            system "clear"
            self.show_top_ten
        end
    end

    #Displays top 10 highest rated businesses based on the user's search
    def show_top_ten

        #prints out list of top 10 businesses, prompts the user to learn more about a business.
        puts "Here are the top 10 places!"
        "-----------------------------------------------------------------------------"
        puts "1. #{@search["businesses"][0]["name"]} - #{@search["businesses"][0]["price"]}"
        puts "2. #{@search["businesses"][1]["name"]} - #{@search["businesses"][1]["price"]}"
        puts "3. #{@search["businesses"][2]["name"]} - #{@search["businesses"][2]["price"]}"
        puts "4. #{@search["businesses"][3]["name"]} - #{@search["businesses"][3]["price"]}"
        puts "5. #{@search["businesses"][4]["name"]} - #{@search["businesses"][4]["price"]}"
        puts "6. #{@search["businesses"][5]["name"]} - #{@search["businesses"][5]["price"]}"
        puts "7. #{@search["businesses"][6]["name"]} - #{@search["businesses"][6]["price"]}"
        puts "8. #{@search["businesses"][7]["name"]} - #{@search["businesses"][7]["price"]}"
        puts "9. #{@search["businesses"][8]["name"]} - #{@search["businesses"][8]["price"]}"
        puts "10. #{@search["businesses"][9]["name"]} - #{@search["businesses"][9]["price"]}"
        puts "-----------------------------------------------------------------------------"
        puts "To learn more about a business, enter the number to the left of it or enter 'M' to return to the main menu."
        
        @list_number = gets.chomp
        if @list_number == "m" || @list_number== "M"
            system "clear"    
            self.main_menu
        elsif (1..10).include?(@list_number.to_i) == false
            system "clear"
            puts "Invalid entry. Please try again."
            puts "---------------------------------------------------------------------------"
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
        puts "Name: #{@bname}"
        puts "Address: #{@baddress}"
        puts "Phone: #{@bphone}"
        puts "Rating: #{@brating}"
        puts "Price:#{@bprice}"
        puts "Yelp Link: #{@blink}"
        puts"----------------------------------------------------------------------------"
        puts"A wishlist is a place where you can save all of the businesses that you would like to visit. Would you like to add this business to your wishlist? (Y/N)"

        yes_or_no = gets.chomp
        self.add_to_wishlist(yes_or_no)
    end
#-----------------------------------------------wishlist---------------------------------------------------#
    #Allows user to add a business to their wishlist, or returns them to the top 10 list
    def add_to_wishlist(yes_or_no)
    case yes_or_no
        when "y"
           new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
            Wishlist.create(business_id: new_business.id, user_id: @user.id)
            system "clear"
            puts "This business has been added to your wishlist! Feel free to add another."
            puts"----------------------------------------------------------------------------"
            self.show_top_ten
        when "Y"
            new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
            Wishlist.create(business_id: new_business.id, user_id: @user.id)
            system "clear"
            puts "This business has been added to your wishlist! Feel free to add another."
            puts"----------------------------------------------------------------------------"
            self.show_top_ten
        when "n"
            system "clear"
            self.show_top_ten
        when "N"
            system "clear"
            self.show_top_ten
        else 
            puts "Invalid entry, please enter Y or N"
            puts"----------------------------------------------------------------------------"
            self.learn_more(@list_number)
        end
    end

    def display_wishlist(wish_bus)
        if wish_bus.length == 0
            system "clear"
            puts "Your wishlist is currently empty. Search for a business to add one!"
            puts"----------------------------------------------------------------------------"
            self.main_menu
        else
            @wish_bus = wish_bus
            counter = 0
            @wish_bus.each do |business|
                puts "#{(counter + 1)}. #{business.name} - #{business.price_range}"
                counter += 1
            end
        puts"----------------------------------------------------------------------------"
        puts "To view additional information or check-in at a business: Enter the number to the left of the business or enter 'M' to return the main menu."
        @input = gets.chomp
        if @input == "m" || @input == "M"
            system "clear"    
            self.main_menu
        elsif  (1..(@wish_bus.length)).include?(@input.to_i) == false
            system "clear"
            puts "Invalid entry. Please try again."
            puts "---------------------------------------------------------------------------"
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
        puts "Name: #{@bname2}"
        puts "Address: #{@baddress2}"
        puts "Phone: #{@bphone2}"
        puts "Rating: #{@brating2}"
        puts "Price:#{@bprice2}"
        puts "Yelp Link: #{@blink2}"
        puts"----------------------------------------------------------------------------"
        puts"If you would like to check-in to this business, enter 'C'. To remove this business, enter 'R'. To return to your wishlist, enter 'W'. (C/R/W)"

        answer = gets.chomp
        self.user_checkin(answer)
    end
#--------------------------------------------checkins-----------------------------------------#

def user_checkin(answer)
    case answer
    when "c"
        Checkin.create(business_id: @bid2, user_id: @user.id)
        remove = Wishlist.where('user_id == ? and business_id ==?',@user.id, @bid2)
        Wishlist.destroy(remove.first.id)
        system "clear"
        puts "You have successfully checked into this business!"
        puts"----------------------------------------------------------------------------"
        self.display_wishlist(User.user_wishlist(@user.id))
    when "C"
        Checkin.create(business_id: @bid2, user_id: @user.id)
        remove = Wishlist.where('user_id == ? and business_id ==?',@user.id, @bid2)
        Wishlist.destroy(remove.first.id)
        system "clear"
        puts "You have successfully checked into this business!"
        puts"----------------------------------------------------------------------------"
        self.display_wishlist(User.user_wishlist(@user.id))
    when "w"
        system "clear"
        self.display_wishlist(@wish_bus)
    when "W"
        system "clear"
        self.display_wishlist(@wish_bus)
    when "r"
        remove = Wishlist.where('user_id == ? and business_id ==?',@user.id, @bid2)
        Wishlist.destroy(remove.first.id)
        system "clear"
        puts "You have successfully removed this business from your wishlist!"
        puts"----------------------------------------------------------------------------"
        self.display_wishlist(User.user_wishlist(@user.id))
    when "R"
        remove = Wishlist.where('user_id == ? and business_id ==?',@user.id, @bid2)
        Wishlist.destroy(remove.first.id)
        system "clear"
        puts "You have successfully removed this business from your wishlist!"
        puts"----------------------------------------------------------------------------"
        self.display_wishlist(User.user_wishlist(@user.id))
    else 
        puts "Invalid entry. If you would like to check-in to this business, enter 'C'. To remove this business, enter 'R'. To return to your wishlist, enter 'W'. (C/R/W)"
        puts"----------------------------------------------------------------------------"
        self.display_details(@input)
    end
end

    def display_checkins(check_bus)
        if check_bus.length == 0
            system "clear"
            puts "You don't have any check-ins to display yet!"
            puts"----------------------------------------------------------------------------"
            self.main_menu
        else
            system "clear"
            @check_bus = check_bus
            counter = 0
            @check_bus.each do |business|
                puts "#{(counter + 1)}. #{business.name} - #{business.price_range}"
                counter += 1
            end
        puts"----------------------------------------------------------------------------"
        puts "Enter 'M' to return to main menu."
        input = gets
        system "clear"
        self.main_menu
        end
    end
    #---------------------------------------top 10 check-ins list-----------------------------------------#
    def ten_most_checked

        business_name = Checkin.get_business_name
        check_ins = Checkin.get_num_checkins

        puts "Check out our top-ten most checked in places!"
        puts "-----------------------------------------------------------------------------"
        puts "1. #{business_name[0]} - #{check_ins[0]} total check-ins"
        puts "2. #{business_name[1]} - #{check_ins[1]} total check-ins"
        puts "3. #{business_name[2]} - #{check_ins[2]} total check-ins"
        puts "4. #{business_name[3]} - #{check_ins[3]} total check-ins"
        puts "5. #{business_name[4]} - #{check_ins[4]} total check-ins"
        puts "6. #{business_name[5]} - #{check_ins[5]} total check-ins"
        puts "7. #{business_name[6]} - #{check_ins[6]} total check-ins"
        puts "8. #{business_name[7]} - #{check_ins[7]} total check-ins"
        puts "9. #{business_name[8]} - #{check_ins[8]} total check-ins"
        puts "10. #{business_name[9]} - #{check_ins[9]} total check-ins"
        puts "-----------------------------------------------------------------------------"
        puts "To learn more about a business, enter the number to the left of it or enter 'M' to return to the main menu."

        @check_number = gets.chomp
        if @check_number == "m" || @check_number == "M"
            system "clear"    
            self.main_menu
        elsif (1..10).include?(@check_number.to_i) == false
            system "clear"
            puts "Invalid entry. Please try again."
            puts "---------------------------------------------------------------------------"
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

        #Prints out the businesses details, prompts the user to add that to their wishlist
        puts "Name: #{@bname3}"
        puts "Address: #{@baddress3}"
        puts "Phone: #{@bphone3}"
        puts "Rating: #{@brating3}"
        puts "Price:#{@bprice3}"
        puts "Yelp Link: #{@blink3}"
        puts"----------------------------------------------------------------------------"
        puts"A wishlist is a place where you can save all of the businesses that you would like to visit. Would you like to add this business to your wishlist? (Y/N)"

        yes_or_no = gets.chomp
        self.add_to_wishlist(yes_or_no)
    end

end