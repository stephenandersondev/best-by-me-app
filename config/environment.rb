require "bundler/setup"
Bundler.require
Dotenv.load("./.env")

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.db")
ActiveRecord::Base.logger = nil
require_all "lib"
