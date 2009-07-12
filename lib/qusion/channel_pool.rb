# encoding: UTF-8
require "singleton"

module Qusion
  class ChannelPool
    include Singleton
    
    class << self
      
      def pool_size=(new_pool_size)
        reset
        @pool_size = new_pool_size
      end
      
      def pool_size
        @pool_size || 5
      end
      
      def reset
        @pool_size = nil
        instance.reset
      end
      
    end
    
    def channel
      @i ||= 1
      @i = (@i + 1) % self.class.pool_size
      pool[@i]
    end
    
    def pool
      initialize_pool unless @pool
      @pool
    end
    
    def initialize_pool
      @pool = []
      self.class.pool_size.times do
        @pool.push(MQ.new)
      end
    end
    
    def reset
      @pool = nil
    end
    
  end
end
