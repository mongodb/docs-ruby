require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'mongo'
end

# start-aws
client = Mongo::Client.new(['<host>'],
                           auth_mech: :aws,
                           user: '<AWS-ACCESS-KEY-ID>',
                           password: '<AWS-SECRET-ACCESS-KEY>')
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
                           })
# end-aws-temp

# start-aws-temp-connection-string
client = Mongo::Client.new(
  'mongodb://<AWS-ACCESS-KEY-ID>:<AWS-SECRET-ACCESS-KEY>@host/?authMechanism=MONGODB-AWS&authMechanismProperties=AWS_SESSION_TOKEN:<AWS-SESSION-TOKEN>')
# end-aws-temp-connection-string

# start-aws-automatic-retrieval
client = Mongo::Client.new(['<host>'],
                           auth_mech: :aws)
)
# end-aws-automatic-retrieval

# start-aws-automatic-retrieval-connection-string
client = Mongo::Client.new(
  'mongodb://host/?authMechanism=MONGODB-AWS')
# end-aws-automatic-retrieval-connection-string