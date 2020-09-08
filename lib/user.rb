require 'tty-prompt'
require 'tty-table'
require 'tty-box'

class User < ActiveRecord::Base
    has_many :checkins
    has_many :businesses, through: :checkins
    has_many :businesses, through: :wishlists

    def create_new_account_or_login
        puts "Would you like to create a new account or sign in to an existing account?"
        puts "Enter '1' to create a new account. Enter '2' to sign in to an existing account."
        user_welcome_input = gets.chomp.to_i
        if user_welcome_input == 1
            puts "Great! Let's create a new account for you!"
            create_new_user_account
        elsif user_welcome_input == 2
            find_existing_user_account
        else
            puts "Invalid Entry, please enter 1 or 2"
            create_new_account_or_login
        end
    end

    def create_new_user_account
        
    end