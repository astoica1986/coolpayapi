module  Service
  extend ActiveSupport::Concern
  included do
    # Every service must respond to #call
    def self.call(*args)
      new(*args).call
    end
  end
end