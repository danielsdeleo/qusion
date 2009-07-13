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
        @pool_size ||= 5
      end
      
      def reset
        @pool_size = nil
        instance.reset
      end
      
    end
    
    attr_reader :pool
    
    def channel
      @i ||= 1
      @i = (@i + 1) % pool_size
      pool[@i]
    end
    
    def pool
      @pool ||= Array.new(pool_size) { MQ.new }
    end
    
    def reset
      @pool = nil
    end
    
    def pool_size
      self.class.pool_size
    end
    
  end
end
