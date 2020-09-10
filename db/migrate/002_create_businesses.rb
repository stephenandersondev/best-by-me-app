class CreateBusinesses < ActiveRecord::Migration[4.2]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.float :rating
      t.string :price_range
      t.string :yelp_link
    end
  end
end
