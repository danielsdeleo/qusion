# encoding: UTF-8
require "singleton"

module Qusion
  class ChannelPool
    include Singleton
    
    class << self
      attr_writer :pool_size
      
      def pool_size
        @pool_size || 5
      end
      
      def reset
        @pool_size = nil
        instance.reset
      end
      
    end
    
    def channel
      channel = @pool.shift
      @pool << channel
      channel
    end
    
    def pool
      @pool ||= initialize_pool
    end
    
    def initialize_pool
      @pool = []
      self.class.pool_size.times do
        @pool << MQ.new
      end
    end
    
    def reset
      @pool = nil
    end
    
  end
end
