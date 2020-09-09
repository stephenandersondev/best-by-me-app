class User < ActiveRecord::Base
    has_many :checkins
    has_many :businesses, through: :checkins
    has_many :businesses, through: :wishlists


    def self.user_wishlist(user_id)
       wishlist = Wishlist.where('user_id == ?',user_id)
       wish_bus = []
       wishlist.each do |item|
            business = Business.find(item.business_id)
            wish_bus << business 
       end
       wish_bus
    end

        def self.user_checkins(user_id)
            checkin_list = Checkin.where('user_id == ?',user_id)
            check_bus = []
            checkin_list.each do |checkin|
                 business = Business.find(checkin.business_id)
                 check_bus << business 
            end
            check_bus
         end
end