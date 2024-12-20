require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'mongo'
end

uri = "<connection string URI>"

Mongo::Client.new(uri) do |client|
  # start-db-coll
  database = client.use('<database name>')
  collection = database[:<collection name>]
  # end-db-coll

  # Start example code here

  # End example code here
end