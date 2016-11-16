module Recipient
  class CreateService
    include Utils
    include Service
    include Virtus.model
    
    attribute :name, String
    attribute :amount, String
    attribute :currency, String
    attribute :recipient_id, String
    attribute :adapter, FaradayAdapter, default: FaradayAdapter.new
    attribute :url, String , default: :default_url
    attribute :auth_token, String
    
    def call
      validate_name!
      adapter.append_headers("Authorization" => "Bearer #{auth_token}")
      response = adapter.connection.post(url) {|conn| conn.body = request_body}
      if response.status == 201
        JSON.parse(response.body)["recipient"]
      else
        log_error(response)
        {}
      end
    end
    
    private
    def request_body
      {recipient: {name: name}}.stringify_keys.to_json
    end
    
    def default_url
      "/api/recipients"
    end
    
    def validate_name!
      raise "Invalid input!" if name.to_s == '' || !name.is_a?(String)
    end
  end
end