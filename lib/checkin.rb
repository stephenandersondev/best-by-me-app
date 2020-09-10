class Checkin < ActiveRecord::Base
  has_many :users
  has_many :businesses

  def self.top_10_checks
    most_checked_in = Checkin.all.group(:business_id).count
    most_checked_in.sort_by { |_k, v| -v }.to_h
  end

  def self.get_businesses
    hash = top_10_checks
    top_10 = hash.keys.take(10)
    final_array = []
    top_10.each { |id| final_array << Business.find(id) }
    final_array
  end

  def self.get_business_name
    businesses = get_businesses
    businesses.collect { |business| business.name }
  end

  def self.get_num_checkins
    hash = top_10_checks
    hash.values.take(10)
  end
end
