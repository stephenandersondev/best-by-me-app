class Wishlist < ActiveRecord::Base
    has_many :users
    has_many :businesses

    def self.user_wishlist(id)
       wishlist = Wishlist.where('user_id == ?',id)
       puts wishlist
    end
end