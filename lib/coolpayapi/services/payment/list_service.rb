module Payment
  class ListService
    include Utils
    include Virtus.model
    include Service
    
    attribute :url, String, default: :default_url
    attribute :name, String
    attribute :adapter, FaradayAdapter, default: FaradayAdapter.new
    attribute :auth_token, String
    
    def call
      adapter.append_headers("Authorization" => "Bearer #{auth_token}")
      response = adapter.connection.get(url)
      if response.status == 200
        JSON.parse(response.body)["payments"]
      else
        log_error(response)
        []
      end
    end
    
    private
    def default_url
      "/api/payments"
    end
  end
end