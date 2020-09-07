class CreateBusinesses < ActiveRecord::Migration[4.2]
    def change
        create_table :businesses do |t|
            t.string :name
            t.string :address
            t.integer :phone_number
            t.string :type
            t.float :rating
            t.string :price_range
            t.string :website
            t.string :hours
        end
    end
end