class AuthorizeService
  include Service
  include Virtus.model
  
  attribute :username
  attribute :apikey
  attribute :adapter, FaradayAdapter, default: FaradayAdapter.new
  attribute :url, String , default: :default_url
  
  def call
    response = adapter.connection.post(url) {|conn| conn.body = request_body}
    if response.status == 200
      token = JSON.parse(response.body)["token"]
      token unless token.empty?
    end
  end
  
  private
  def request_body
    {username: username, apikey: apikey}.to_json
  end
  
  def default_url
    "/api/login"
  end
end