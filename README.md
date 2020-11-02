BestByMe App 
========================

![Best-By-Me_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/sign_in.png?raw=true)

## About

Welcome to the BestByMe CLI app! This app was developed by Stephen Anderson (@stephenandersondev) and Ciara Picou (@ciara-picou) as part of week 3 of the Flatiron School Software Engineering program.

## Demo Video
https://youtu.be/ubLDJvNRf8Y

## Another Business Search Engine? Why should I care?

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/main_menu.png?raw=true)

BestByMe is designed for users who do not have the time or interest to spend hours reading reviews and researching businesses. 
When a user enters a business type and a zip code, our app responds with the top ten most highly rated business of that type in their area. 

 ![Best-By-Me_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/top_ten.png?raw=true)


## Installation

**1.** Fork and Clone this repository.


Our app relies on the following gems:
  ```ruby
  gem "activerecord", '~> 5.2'
  gem "sinatra-activerecord"
  gem "sqlite3", '~> 1.3.6'
  gem "pry"
  gem "require_all"
  gem "faker"
  gem "rake"
  gem "http"
  gem "tty-prompt"
  gem "dotenv"
  gem "pastel"
  gem "tty-font"
  ```

**2.** Run bundle install to install all the gems listed above :
```ruby
$ bundle install
```
**3.** Use this link to guide you through the process of acquiring your own Yelp API key:

https://www.yelp.com/developers/documentation/v3/authentication

**4.** Inside of your cloned BestByMe repository, create a .env file in the root directory. Then input the following code snippet into .env with your newly acquired API key:
```ruby
export YELP_KEY="place-your-yelp-API-key-here"
```

**5.** You're now all set! To run the app, make sure you're in the root directory and simply run:
```ruby
$ ruby bin/run.rb
```

## Basic Usage

To use BestByMe, you must first create an account.

After you've logged in to your account, you will be directed to the main menu where you have the option of viewing your wishlist, check-ins, and the most visited businesses or beginning your search. You may scroll through 
your options with the arrow keys and select an option by pressing enter.

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/main_menu.png?raw=true)

To begin a new search, you simply enter a zip code and the type of business you are looking for.

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/search.png?raw=true)

BestByMe will display the top-ten businesses of that type in your area.

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/search_top_ten.png?raw=true)

To learn more about a business, you may enter the number to the left of the business. This will allow you to view its address, phone number, rating, price range and the yelp page link for that business. 

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/business_detail.png?raw=true)

At this point, you will have the option to add the business to your wishlist. Enter 'Y' if you would like to visit this business or 'N' if this business fails to spark your interest.

Entering 'N' will take you back to the top 10 list, where you may explore other businesses or enter 'M' to return to the main menu.
    
From the main menu, you can actually view your very own wishlist.

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/wishlist.png?raw=true)

Upon visiting a business, you may add it to your check-in list. To do this you must go to your wishlist where you are instructed to check-in to the business by entering 'C'. This step will remove the business from your wishlist and add it to your check-in list. You will be redirected to your wishlist where you can see that the item has been removed.

![BestByMe_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/check_in.png?raw=true)

From the main menu, you can even view your check-in history by selecting 'View my check-ins'.

![Best-By-Me_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/check_ins.png?raw=true)

You may also view our most visited business by selecting that option from the main menu. You may explore our most popular businesses by following the same steps you used to explore your personalized top ten list.

![Best-By-Me_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/top_ten.png?raw=true)

You can even see who all has checked-in at these top businesses.

![Best-By-Me_Interface](https://github.com/stephenandersondev/best-by-me-app/blob/master/img/user_list.png?raw=true)

We hope our app introduces you to many new and exciting places! 😊




