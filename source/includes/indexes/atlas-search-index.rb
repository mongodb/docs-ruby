require 'mongo'

# Replace the placeholders with your credentials
uri = "<connection string>"

# Sets the server_api field of the options object to Stable API version 1
options = { server_api: { version: "1" }}

# Creates a new client and connect to the server
client = Mongo::Client.new(uri, options)

database = client.use('sample_mflix')
collection = database[:embedded_movies]

# start-create-search-index
# Creates indexes on all dynamically indexable fields with a default index name
collection.search_indexes.create_one(
  { mappings: { dynamic: true } } 
)

# Creates an index on the specified field with the specified index name
index_definition = {
  mappings: {
    dynamic: false,  
    fields: { 
      fullplot: { type: 'string' }
    }
  }
}
collection.search_indexes.create_one(index_definition, name: 'mySearchIndex')
# end-create-search-index

# start-create-multiple-search-indexes
index_spec_1 = {
  name: 'searchIndex_plot',
  type: 'search',
  definition: {
    mappings: {
      dynamic: false,  
      fields: { 
        plot: { type: 'string' }
      }
    }
  }
}

index_spec_2 = {
  name: 'vsIndex_plot_embedding',
  type: 'vectorSearch',
  definition: {
    fields: [
      {
        type: "vector",
        path: "plot_embedding",
        numDimensions: 1536,
        similarity: "dotProduct"
      }
    ]
  }
}

collection.search_indexes.create_many([index_spec_1, index_spec_2])
# end-create-multiple-search-indexes

# start-update-search-indexes
updated_definition = {
  mappings: {
    dynamic: false,  
    fields: { fullplot: { type: 'string' } }
    }
}

# Specifies the index to update by using the index name
collection.search_indexes.update_one(updated_definition, name: 'searchIndex_plot')

# Specifies the index to update by using the index id
collection.search_indexes.update_one(updated_definition, id: <index id>)
# end-update-search-indexes

# start-drop-search-index
# Specifies the index to delete by using the index name
collection.search_indexes.drop_one(name: 'searchIndex_plot')

# Specifies the index to delete by using the index id
collection.search_indexes.drop_one(id: <index id>)
# end-drop-search-index

# start-list-entire-spec
puts collection.search_indexes.collect(&:to_json)
# end-list-entire-spec

# start-list-certain-elements
collection.search_indexes.each do |index_spec|
  p index_spec['id']
  p index_spec['name']
  p index_spec['status']
  p index_spec['queryable']
  p index_spec['latestDefinition']
end
# end-list-certain-elements
