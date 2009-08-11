# encoding: UTF-8
unless defined?(QUSION_ROOT)
  QUSION_ROOT = File.dirname(__FILE__) + '/'
end

require "eventmachine"
require "mq"

require QUSION_ROOT + "qusion/server_spy"
require QUSION_ROOT + "qusion/em"
require QUSION_ROOT + "qusion/amqp"
require QUSION_ROOT + "qusion/channel_pool"
require QUSION_ROOT + "qusion/amqp_config"

module Qusion
  def self.start(*opts)
    amqp_opts = AmqpConfig.new(*opts).config_opts
    AMQP.start_web_dispatcher(amqp_opts)
  end
  
  def self.channel
    ChannelPool.instance.channel
  end
  
  def self.channel_pool_size(new_pool_size)
    ChannelPool.pool_size = new_pool_size
  end
end
