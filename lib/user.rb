require 'tty-prompt'
require 'tty-table'
require 'tty-box'

class User < ActiveRecord::Base
    has_many :checkins
    has_many :businesses, through: :checkins
    has_many :businesses, through: :wishlists

#Prompts user to either login or create a new account.
    def self.create_new_account_or_login
        prompt = TTY::Prompt.new
        prompt.select("Would you like to create a new account or sign in to an existing account?") do |menu|
        #calls the appropriate method based on user input.
        menu.choice 'sign in to an existing account', -> {User.sign_into_existing_account}
        menu.choice "create a new account", -> {User.create_new_user_account}
        end
    end


#Walks user through the process of creating a new account. 
    def self.create_new_user_account
        puts "\n\e[95mPlease enter your username\e[0m"
        user_username_input = gets.chomp 
        user = User.find_by(username: user_username_input) 
        
        if user == nil
            puts "\e[95mYour username has been saved. Please enter your first name.\e[0m"
            user_name = gets.chomp
            password = TTY::Prompt.new
            user_password = password.mask("\e[95mPlease enter your password.\e[0m")
            puts "\n\e[93m You're all set up #{user_name}! Your username is #{user_username_input}.\e[0m]"
            user =  User.create(name:user_name, username: user_username_input, password: user_password)
        else
            puts "\n\e[91mSorry that username is already taken.\e[0m"
            User.create_new_user_account
        end
    user
end


#Guides user through the login process.
    def self.sign_into_existing_account
        puts"\n\e[95mPlease enter your username.\e[0m"
        user_username = gets.chomp
        password = TTY::Prompt.new
        user_password = password.mask("\e[95mPlease enter your password.\e[0m")
        user = User.find_by(username: user_username, password: user_password)
        system "clear"
        #Checks to see whether a matching username can be found.
        #If a match is found, the user is logged in and greeted by name.
        # If no match is found, the user to is instructed to re-enter the information. 
        if user == nil
        puts "\n\e[91mThere is no user found with that username and password. Please try again.\e[0m"
            User.create_new_account_or_login
        else
            user = User.find_by(username: user_username, password: user_password)
            puts "\n\e[93mHello #{user.name}!"
        
        end
      user
    end
end