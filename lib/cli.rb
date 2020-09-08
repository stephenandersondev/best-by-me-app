require 'pry'

class Cli

    attr_reader :zipcode, :type, :search
    
    #initializes a new CLI instance and starts the welcome and prompt.
    def initialize
        system "clear"
        puts 'Welcome to BestByMe, the best resource for top-rated businesses in your area!'
        self.login_prompt
    end

    #Sends the user to the login screen, once authorized sends them to the main menu.
    def login_prompt
        @user = User.create_new_account_or_login
        # binding.pry
        self.main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new
        prompt.select("What would you like to do?") do |menu|
        #calls the appropriate method based on user input.
        menu.choice 'Search for a business', -> {self.search_prompt}
        menu.choice 'View my wishlist', -> {Wishlist.user_wishlist(@user.id)}
        menu.choice 'View my checkins', -> {Checkin.user_checkins(@user)}
        end
    end

    #Prompts the user to enter a zip code and business search term so the data can be fetched.
    def search_prompt
        system "clear"
        puts "To get started, please enter the zip code for your business search!"
        @zipcode = gets.chomp

        puts "Next, please enter the type of business you're looking for!"
        @type = gets.chomp

        @search = GetBusinesses.search(term: @type,location: @zipcode)

        system "clear"
        self.show_top_ten
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
        puts "To learn more about a business, enter the number to the left of it."
        
        @list_number = gets.chomp

        system "clear"
        self.learn_more(@list_number)
    end

    #Allows the user to enter number of business they wish to learn more about.
    def learn_more(number)
        
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
end