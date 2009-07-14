# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe "Qusion Convenience Methods" do
  
  it "should get a channel from the pool" do
    channel_pool = mock("channel pool")
    ChannelPool.should_receive(:instance).and_return(channel_pool)
    channel_pool.should_receive(:channel)
    Qusion.channel
  end
  
  it "should set the channel pool size" do
    ChannelPool.should_receive(:pool_size=).with(7)
    Qusion.channel_pool_size(7)
  end
  
  it "should load the configuration and setup AMQP for the webserver" do
    config = mock("config")
    AmqpConfig.should_receive(:new).and_return(config)
    config.should_receive(:config_opts).and_return("tasty cookie")
    AMQP.should_receive(:start_web_dispatcher).with("tasty cookie")
    Qusion.start
  end
  
end