module Payment
  class CreateService
    include Utils
    include Service
    include Virtus.model
    
    attribute :amount, Integer
    attribute :currency, String
    attribute :recipient_id, String
    attribute :adapter, FaradayAdapter, default: FaradayAdapter.new
    attribute :url, String , default: :default_url
    attribute :auth_token, String
    
    def call
      binding.pry
      validate_input!
      adapter.append_headers("Authorization" => "Bearer #{auth_token}")
      response = adapter.connection.post(url) {|conn| conn.body = request_body}
      if response.status == 201
        JSON.parse(response.body)["payment"]
      else
        log_error(response)
        {}
      end
    end
    
    private
    def request_body
      {payment: {amount: amount, currency: currency, recipient_id: recipient_id}}.stringify_keys.to_json
    end
    
    def default_url
      "/api/payments"
    end
    
    def validate_input!
      raise "Invalid input" if recipient_id.to_s == '' || !recipient_id.is_a?(String)
      raise "Invalid input" if currency.to_s == '' || !currency.is_a?(String)
      raise "Invalid input!" if amount.to_i == 0 || !amount.is_a?(Numeric)
    end
  end
end