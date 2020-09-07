class Cli

    attr_reader :zipcode, :type, :search
    
    def initialize
        puts 'Welcome to BestByMe, the best resource for top-rated businesses in your area!'
        self.prompt
    end

    def prompt
        puts "To get started, please enter the zip code for your business search!"
        @zipcode = gets.chomp
        puts "Next, please enter the type of business you're looking for!"
        @type = gets.chomp
        @search = GetBusinesses.search(term: @type,location: @zipcode)
        self.show_top_ten
    end

    def show_top_ten
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
        self.learn_more(@list_number)
    end

    def learn_more(number)
        directory = @search["businesses"][(number.to_i - 1)]

        #Business_detail_variables
        @bname = directory["name"]
        @baddress = (directory["location"]["display_address"]).join(" ")
        @bphone = directory["display_phone"]
        @brating = directory["rating"]
        @bprice = directory["price"]
        @blink = directory["url"]

        puts "Name: #{@bname}"
        puts "Address: #{@baddress}"
        puts "Phone: #{@bphone}"
        puts "Rating: #{@brating}"
        puts "Price:#{@bprice}"
        puts "Yelp Link: #{@blink}"
        puts"----------------------------------------------------------------------------"
        puts"A wishlist is a place where you can save all of the businesses that you would like to visit. Would you like to add this business to your wishlist? (Y/N)"
        answer = gets.chomp
        self.add_to_wishlist(answer)
    end

    def add_to_wishlist(answer)
    case answer
        when "y"
           new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
            # Wishlist.create(business_id: new_business.id, #Add user thats logged in)
        when "Y"
            new_business = Business.create(name: @bname, address: @baddress, phone_number: @bphone, rating: @brating, price_range: @bprice, yelp_link: @blink)
            # Wishlist.create(business_id: new_business.id, #Add user thats logged in)
        when "n"
            self.show_top_ten
        when "N"
            self.show_top_ten
        else 
            puts "Invalid entry, please enter Y or N"
            puts"----------------------------------------------------------------------------"
            self.learn_more(@list_number)
        end
    end
end