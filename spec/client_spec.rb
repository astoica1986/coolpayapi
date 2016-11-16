require 'spec_helper'
describe Coolpayapi::Client, vcr: { record: :new_episodes }  do
  let(:client){Coolpayapi::Client.new}

  it "responds to authorize!" do
    expect(client).to respond_to(:authorize!)
  end
  
  it "returns an auth token for valid credentials" do
    valid_client = client #uses default credentials
    expect {valid_client.authorize!}.not_to raise_error
    expect(valid_client.authorize!).to be_an_instance_of(String)
  end

  it "invalidates wrong credentials credentials" do
    invalid_client = Coolpayapi::Client.new(username: 'jack_sparrow', apikey: 'savy')
    expect{invalid_client.authorize!}.to raise_error(RuntimeError, "Unauthorized!")
  end
  
  it "responds to list/create payment and recipient" do
    expect(client).to respond_to(:list_payments, :list_recipients,
                                 :create_recipient, :create_payment)
  end
  
  it "returns a list of payments" do
    response = client.list_payments
    expect(response).to be_an_instance_of(Array)
    unless response.empty?
      response.each do |r|
        expect(r).to be_an_instance_of(Hash)
        expect(r).to include("id", "amount", "currency", "recipient_id", "status")
      end
    end
  end

  it "returns a list of recipients" do
    response = client.list_recipients
    expect(response).to be_an_instance_of(Array)
    unless response.empty?
      response.each do |r|
        expect(r).to be_an_instance_of(Hash)
        expect(r).to include("id", "name")
      end
    end
  end
  
  it "creates a recipient" do
    response = client.create_recipient(name: 'Adrian Tester')
    expect(response).to be_an_instance_of(Hash)
    expect(response).to include("id", "name")
    expect(response["name"]).to eq('Adrian Tester')
  end
  
  it "does not create invalid recipient" do
    expect{client.create_recipient(name: "")}.to raise_error(RuntimeError, "Invalid input!")
  end
  
  it "sends a payment to a recipient" do
    recipient = client.create_recipient(name: 'Adrian Tester')
    payment_params =  {amount: 20, currency: "GBP", recipient_id: recipient["id"]}
    payment_response = client.create_payment(payment_params)
    expect(payment_response).to include("id", "amount", "currency", "recipient_id", "status")
    expect(payment_response["recipient_id"]).to eq(recipient["id"])
  end

  it "does not send an invalid payment" do
    payment_params =  {}
    expect{client.create_payment(payment_params)}.to raise_error(RuntimeError, "Invalid input")
  end
end
