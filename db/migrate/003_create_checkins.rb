class CreateCheckins < ActiveRecord::Migration[4.2]
    def change
        create_table :checkins do |t|
            t.integer :user_id
            t.integer :business_id
        end
    end
end