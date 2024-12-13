require 'mongo'

# Replace the placeholders with your credentials
uri = "mongodb+srv://lindsey:me123@atlascluster.spm1ztf.mongodb.net/?retryWrites=true&w=majority&appName=AtlasCluster"

# Set the server_api field of the options object to Stable API version 1
options = { server_api: { version: "1" }}

# Create a new client and connect to the server
client = Mongo::Client.new(uri, options)
database = client.use('sample_mflix')
collection = database[:movies]

# start-index-single
# Create an index on the "title" field
index = collection.indexes.create_one({ title: 1 })
puts "Index created: #{index}"
# end-index-single

# start-index-single-query
# Find a document with the title "Sweethearts"
filter = { title: 'Sweethearts' }
doc = collection.find(filter).first

if doc
    puts doc.to_json
  else
    puts "No document found"
  end
# end-index-single-query

# start-check-single-index
# List all indexes on the collection
all_indexes = collection.indexes
all_indexes.each do |index_spec|
  puts index_spec.to_json
end
# end-check-single-index