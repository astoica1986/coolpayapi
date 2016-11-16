require 'virtus'
require 'faraday'
class FaradayAdapter
  include Virtus.model
  attribute :retry_call, Boolean, default: true
  attribute :retry_config, Hash, default: {max: 2, interval: 0.05,interval_randomness: 0.5, backoff_factor: 2}
  attribute :headers , Hash, default: {'Content-Type' => 'application/json'}
  BASE_URI = 'https://coolpay.herokuapp.com'
  
  def connection
    Faraday.new(:url => BASE_URI) do |faraday|
      faraday.adapter  Faraday.default_adapter
      faraday.request(:retry, retry_config) if retry_call
      faraday.headers = headers
      faraday.response :logger
    end
  end
  
  def append_headers(additional_headers ={})
    self.headers = self.headers.merge(additional_headers)
  end
end
