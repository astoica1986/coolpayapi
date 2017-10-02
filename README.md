# Coolpayapi

This was created as part of a coding exercise for a former job.
It is the client to the sandbox version of a major payments engine API.

## Installation

Add this line to your application's Gemfile:


## Usage
extract folder
cd to /coolpayapi
bin/setup or bundle install
rspec spec -> runs specs
rake console -> loads the gem in pry

client = Coolpayapi::Client.new (uses the default credentials from
 credentials.rb)
or

client = Coolpayapi::Client.new(username: "UserName" ,
 apikey: "someapikey")
recipient = client.create_recipient(name: 'Adrian Tester')
payment_params =  {amount: 20, currency: "GBP", 
recipient_id: recipient["id"]}
payment_response = client.create_payment(payment_params)

client.list_recipients
client.list_payments
client.list_recipients(name: "Adrian Tester")
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

