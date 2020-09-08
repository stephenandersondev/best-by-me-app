class Checkin < ActiveRecord::Base
    has_many :users
    has_many :businesses

    def user_checkins(user)
        Checkin.all(user_id: user.id)
    end
end