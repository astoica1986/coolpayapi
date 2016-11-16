module Recipient
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
        JSON.parse(response.body)["recipients"]
      else
        log_error(response)
        []
      end
    end
    
    private
    def default_url
      query_string = name.present? ? "?name=#{name}" : ""
      "/api/recipients#{query_string}"
    end
  end
end