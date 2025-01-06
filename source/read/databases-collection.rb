require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'mongo'
end

uri = '<connection string>'

Mongo::Client.new(uri) do |client|
    # Access the database and collection
    # start-db-coll
    client = Mongo::Client.new(
        ['IP_ADDRESS_001:27017'],
        database: 'test_database',
        read: { mode: :secondary_preferred },
        local_threshold: 35
      )

    database = client.database

    collection = database[:example_collection]
    result = collection.find({}).first
    puts result
    # end-db-coll

