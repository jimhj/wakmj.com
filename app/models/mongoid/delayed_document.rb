# Sidekiq DelayedDocument for Mongoid
module Mongoid
  module DelayedDocument
    extend ActiveSupport::Concern

    included do
      include Sidekiq::Worker
      sidekiq_options :retry => false
      sidekiq_options :verbose => true
      sidekiq_options :concurrency => 5
    end

    def perform(method_name, *args)
      self.class.send(method_name, *args)
    end
  end
end