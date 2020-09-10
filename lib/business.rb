class Business < ActiveRecord::Base
  has_many :checkins
  has_many :users, through: :checkins
end
