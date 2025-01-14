require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'mongo'
end

# start-default
client = Mongo::Client.new('<host>',
                           user: '<username>',
                           password: '<password>')
# end-default

# start-default-connection-string
client = Mongo::Client.new('mongodb://username:password@host')
# end-default-connection-string

# start-scram-sha-256
client = Mongo::Client.new('<host>',
                           user: '<username>',
                           password: '<password>',
                           auth_mech: :scram256 )
# end-scram-sha-256

# start-scram-sha-256-connection-string
client = Mongo::Client.new("mongodb://username:password@host/?authMechanism=SCRAM-SHA-256")
# end-scram-sha-256-connection-string

# start-scram-sha-1
client = Mongo::Client.new('<host>',
                           user: '<username>',
                           password: '<password>',
                           auth_mech: :scram )
# end-scram-sha-1

# start-scram-sha-1-connection-string
client = Mongo::Client.new("mongodb://username:password@host/?authMechanism=SCRAM-SHA-1")
# end-scram-sha-1-connection-string

# start-mongodb-x509
client = Mongo::Client.new('<host>',
                           auth_mech: :mongodb_x509,
                           ssl: true,
                           ssl_cert: '/path/to/client.pem',
                           ssl_key: '/path/to/client.pem',
                           ssl_ca_cert: '/path/to/ca.pem' )
# end-mongodb-x509

# start-mongodb-x509-connection-string
client = Mongo::Client.new("mongodb://username:password@host/?authMechanism=MONGODB-X509")
# end-mongodb-x509-connection-string

# start-aws
client = Mongo::Client.new(['<host>'],
                           auth_mech: :aws,
                           user: '<AWS-ACCESS-KEY-ID>',
                           password: '<AWS-SECRET-ACCESS-KEY>' )
# end-aws

# start-aws-connection-string
client = Mongo::Client.new(
  'mongodb://<AWS-ACCESS-KEY-ID>:<AWS-SECRET-ACCESS-KEY>@host/?authMechanism=MONGODB-AWS')
# end-aws-connection-string

# start-aws-temp
client = Mongo::Client.new(['<host>'],
                           auth_mech: :aws,
                           user: '<AWS-ACCESS-KEY-ID>',
                           password: '<AWS-SECRET-ACCESS-KEY>',
                           auth_mech_properties: {
                             aws_session_token: '<AWS-SESSION-TOKEN>',
                           } )
# end-aws-temp

# start-aws-temp-connection-string
client = Mongo::Client.new(
  'mongodb://<AWS-ACCESS-KEY-ID>:<AWS-SECRET-ACCESS-KEY>@host/?authMechanism=MONGODB-AWS&authMechanismProperties=AWS_SESSION_TOKEN:<AWS-SESSION-TOKEN>')
# end-aws-temp-connection-string

# start-aws-automatic-retrieval
client = Mongo::Client.new(['<host>'],
                           auth_mech: :aws )
)
# end-aws-automatic-retrieval

# start-aws-automatic-retrieval-connection-string
client = Mongo::Client.new(
  'mongodb://host/?authMechanism=MONGODB-AWS')
# end-aws-automatic-retrieval-connection-string