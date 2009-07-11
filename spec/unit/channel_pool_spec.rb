# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe ChannelPool do
  MQ = Object.new
  
  before(:each) do
    ChannelPool.reset
  end
  
  it "should be singleton" do
    lambda { ChannelPool.new }.should raise_error
  end
  
  it "should adjust the pool size" do
    ChannelPool.pool_size = 5
    ChannelPool.pool_size.should == 5
  end
  
  it "should create a pool of AMQP channels" do
    ChannelPool.pool_size = 3
    MQ.should_receive(:new).exactly(3).times
    ChannelPool.instance.pool
  end
  
  it "should default to a pool size of 5" do
    MQ.should_receive(:new).exactly(5).times.and_return("swanky")
    ChannelPool.instance.pool
    ChannelPool.instance.instance_variable_get(:@pool).should == %w{ swanky swanky swanky swanky swanky}
  end
  
  it "should return a channel in a round-robin" do
    ChannelPool.instance.instance_variable_set(:@pool, [1,2,3,4,5])
    [1,2,3,4,5,1,2,3,4,5].each do |i|
      ChannelPool.instance.channel.should == i
    end
    
  end
  
end

describe Qusion do
  it "should provide a convenience method to get a channel from the pool" do
    channel_pool = mock("channel pool")
    ChannelPool.should_receive(:instance).and_return(channel_pool)
    channel_pool.should_receive(:channel)
    Qusion.channel
  end
end
