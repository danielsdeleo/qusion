# encoding: UTF-8
require "singleton"

module Qusion
  
  # ChannelPool maintains a pool of AMQP channel objects that can be reused.
  # The motivation behind this is that if you were to use MQ.new to create a 
  # new channel for every request, your AMQP broker could be swamped trying to
  # maintain a bunch of channels that you're only using once.
  #
  # To use the channel pool, just replace <tt>MQ.new</tt> in your code with <tt>Qusion.channel</tt>
  # 
  #   # Instead of this:
  #   MQ.new.queue("my-worker-queue")
  #   # Do this:
  #   Qusion.channel.queue("my-worker-queue")
  #
  # By default, ChannelPool maintains a pool of 5 channels. This can be adjusted with
  # <tt>ChannelPool.pool_size=()</tt> or <tt>Qusion.channel_pool_size()</tt>
  # The optimal pool size is not yet known, but I suspect you might need a 
  # larger value if using Thin in production, and a smaller value otherwise.
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
