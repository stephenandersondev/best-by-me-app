class User < ActiveRecord::Base
    has_many :checkins
    has_many :businesses, through: :checkins
    has_many :businesses, through: :wishlists

#--------------------------------------------------Authoriziation------------------------------------------#

    #Prompts user to either login or create a new account.
    def self.create_new_account_or_login
        prompt = TTY::Prompt.new
        prompt.select("Would you like to create a new account or sign in to an existing account?") do |menu|
        #calls the appropriate method based on user input.
        menu.choice 'sign in to an existing account', -> {User.sign_into_existing_account}
        menu.choice "create a new account", -> {User.create_new_user_account}
        end
    end


#Walks user through the process of creating a new account. 
    def self.create_new_user_account
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
            User.create_new_user_account
        end
    user
end


#Guides user through the login process.
    def self.sign_into_existing_account
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
            User.create_new_account_or_login
        else
            user = User.find_by(username: user_username, password: user_password)
            puts "\n\e[93mHello #{user.name}!"
        
        end
      user
    end

    #--------------------------------------------Wishlist------------------------------------------#

    def user_wishlist
       wishlist = Wishlist.where('user_id == ?',self.id)
       @wish_bus = []
       wishlist.each do |item|
            business = Business.find(item.business_id)
            @wish_bus << business 
       end
       self.display_wishlist
    end

    
    def display_wishlist
        system "clear"
        counter = 0
        @wish_bus.each do |business|
            puts "#{(counter + 1)}. #{business.name} - #{business.price_range}"
            counter += 1
        end
       puts"----------------------------------------------------------------------------"
       puts "To view additional information or check-in at a business: Enter the number to the left of the business."
       @input = gets.chomp
       self.display_details(@input)
    end
    
    
    def display_details(input)
        system "clear"
        selection = @wish_bus[(input.to_i - 1)]

        #Business_detail_variables
        @bname = selection.name
        @baddress = selection.address
        @bphone = selection.phone_number
        @brating = selection.rating
        @bprice = selection.price_range
        @blink = selection.yelp_link
        @bid = selection.id

        #Prints out the businesses details, prompts the user to add that to their wishlist
        puts "Name: #{@bname}"
        puts "Address: #{@baddress}"
        puts "Phone: #{@bphone}"
        puts "Rating: #{@brating}"
        puts "Price:#{@bprice}"
        puts "Yelp Link: #{@blink}"
        puts"----------------------------------------------------------------------------"
        puts"Would you like to check-in here? (Y/N)"

        yes_or_no = gets.chomp
        self.user_checkin(yes_or_no)
    end

    def user_checkin(yes_or_no)
        case yes_or_no
        when "y"
            Checkin.create(business_id: @bid, user_id: self.id)
            remove = Wishlist.where('user_id == ? and business_id ==?',self.id, @bid)
            Wishlist.destroy(remove.first.id)
            system "clear"
            puts "You have successfully checked into this business!"
            puts"----------------------------------------------------------------------------"
            self.user_wishlist
        when "Y"
            Checkin.create(business_id: @bid, user_id: self.id)
            remove = Wishlist.where('user_id == ? and business_id ==?',self.id, @bid)
            Wishlist.destroy(remove.first.id)
            system "clear"
            puts "You have successfully checked into this business!"
            puts"----------------------------------------------------------------------------"
            self.user_wishlist
        when "n"
            system "clear"
            self.display_wishlist
        when "N"
            system "clear"
            self.display_wishlist
        else 
            puts "Invalid entry, please enter Y or N"
            puts"----------------------------------------------------------------------------"
            self.display_details(@input)
        end
    end

    #-----------------------------------------Check-in list------------------------------------------#

        def user_checkins
            checkin_list = Checkin.where('user_id == ?',self.id)
            @check_bus = []
            checkin_list.each do |checkin|
                 business = Business.find(checkin.business_id)
                 @check_bus << business 
            end
            self.display_checkins
         end
     
         
         def display_checkins
             system "clear"
             counter = 0
             @check_bus.each do |business|
                 puts "#{(counter + 1)}. #{business.name} - #{business.price_range}"
                 counter += 1
             end
            puts"----------------------------------------------------------------------------"
            puts "Enter 'M' to return to main menu."
            input = gets
            
         end

end