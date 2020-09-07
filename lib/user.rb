class User < ActiveRecord::Base
    has_many :checkins
    has_many :businesses, through: :checkins
    has_many :businesses, through: :wishlists
end