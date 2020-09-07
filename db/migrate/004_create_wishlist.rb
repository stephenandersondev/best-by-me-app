class CreateWishlist < ActiveRecord::Migration[4.2]
    def change
        create_table :wishlists do |t|
            t.integer :user_id
            t.integer :business_id
        end
    end
end