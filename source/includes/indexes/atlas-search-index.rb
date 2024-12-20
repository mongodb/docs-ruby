require 'mongo'

# Replace the placeholders with your credentials
uri = "<connection string>"

# Sets the server_api field of the options object to Stable API version 1
options = { server_api: { version: "1" }}

# Creates a new client and connect to the server
client = Mongo::Client.new(uri, options)

database = client.use('sample_mflix')
collection = database[:movies]

# start-create-search-index
index_definition = { 
  name: '<index name>',
  definition: {
    mappings: {
      dynamic: false,  
      fields: { 
        <field name 1>: {type: '<field type>'},
        <field name 2>: {type: '<field type>'}
      }
    }
  }
}
collection.database.command(
  createSearchIndexes: '<collection name>',
  indexes: [index_definition]
)
# end-create-search-index

# start-update-search-indexes
updated_definition = {
  mappings: {
    dynamic: false,  
    fields: { <updated field name>: { type: '<field type>' } }
    }
}
collection.database.command(
    updateSearchIndex: '<collection name>',
    name: '<index name>',
    definition: updated_definition
)
# end-update-search-indexes

# start-drop-search-index
collection.database.command(
    dropSearchIndex: '<collection name>',
    name: '<index name>'
)
# end-drop-search-index

client.close