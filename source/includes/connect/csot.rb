# start-csot-overrides
require 'mongo'

# Replace the placeholder with your connection string
uri = "<connection string>"

# Sets a client-level timeout configuration
options = { timeoutMS: 30000 }
client = Mongo::Client.new(uri, options)

begin
  db = client.use('test-db')
  collection = db[:test-collection]

  # Perform a query with an operation-level timeout configuration,
  # overriding the client-level configuration
  docs = collection.find({}, timeout_ms: 10000).to_a

  docs.each { |doc| puts doc }
ensure
  client.close
end
# end-csot-overrides

# start-csot-iterable
cursor = collection.find()

cursor.each do |movie|
  puts movie['imdb']
end
# end-csot-iterable
