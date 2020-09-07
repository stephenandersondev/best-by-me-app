class Checkin < ActiveRecord::Base
    has_many :users
    has_many :businesses
end