module Coolpayapi
  class Client
    include Virtus.model
    attribute :username, String, default: Coolpayapi::USERNAME
    attribute :apikey, String, default: Coolpayapi::APIKEY
    attribute :authorization, String
    
    def authorize!
      self.authorization ||= AuthorizeService.call(username: username, apikey: apikey)
      if authorization.nil?
        raise 'Unauthorized!'
      else
        authorization
      end
    end
    
    def list_recipients(name: nil)
      authorize!
      Recipient::ListService.call(auth_token: authorization, name: name)
    end
    
    def create_recipient(name: nil)
      authorize!
      Recipient::CreateService.call(auth_token: authorization, name: name) if name
    end
    
    def list_payments
      authorize!
      Payment::ListService.call(auth_token: authorization)
    end
    
    def create_payment(params={})
      authorize!
      Payment::CreateService.call(payment_params(params))
    end
    
    def payment_params(params)
      authorize!
      { amount: params[:amount], currency: params[:currency], recipient_id: params[:recipient_id],
        auth_token: authorization}
    end
  end
end