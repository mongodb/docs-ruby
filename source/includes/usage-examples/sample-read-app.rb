require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'mongo'
end

uri = '<connection string>'

Mongo::Client.new(uri) do |client|
  database = client.use('<database name>')
  collection = database['<collection name>']

 # Start example code here

  # End example code here

  # Wait for the operations to complete before closing client
  # Note: This example uses sleep for brevity and does not guarantee all
  # operations will be completed in time
  sleep(1)
  client.close
end