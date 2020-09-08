class Business < ActiveRecord::Base
    has_many :checkins
    has_many :users, through: :checkins

    def self.top_ten
     top_ten = Checkin.all.
      
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
end