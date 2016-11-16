module Utils
  extend ActiveSupport::Concern
  
  private
  def log_error(response)
    puts "Network or Coolpayapi API issue.\n
      The call failed with status #{response.status} and error #{response.body}
      Please contact the Coolpayapi support if the problem persists\n"
  end
end