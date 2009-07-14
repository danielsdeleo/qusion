# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe ChannelPool do
  MQ = Object.new
  
  before(:each) do
    ChannelPool.reset
    @channel_pool = ChannelPool.instance
  end
  
  it "should be singleton" do
    lambda { ChannelPool.new }.should raise_error
  end
  
  it "should adjust the pool size" do
    ChannelPool.pool_size = 5
    ChannelPool.pool_size.should == 5
  end
  
  it "should reset itself when the pool size is set" do
    ChannelPool.should_receive(:reset)
    ChannelPool.pool_size = 23
  end
  
  it "should create a pool of AMQP channels" do
    ChannelPool.pool_size = 3
    MQ.should_receive(:new).exactly(3).times
    @channel_pool.pool
  end
  
  it "should default to a pool size of 5" do
    MQ.should_receive(:new).exactly(5).times.and_return("swanky")
    @channel_pool.pool
    @channel_pool.instance_variable_get(:@pool).should == %w{ swanky swanky swanky swanky swanky}
  end
  
  it "should return a channel in a round-robin" do
    @channel_pool.instance_variable_set(:@pool, [1,2,3,4,5])
    @channel_pool.channel.should == 3
    @channel_pool.channel.should == 4
    @channel_pool.channel.should == 5
    @channel_pool.channel.should == 1
    @channel_pool.channel.should == 2
    @channel_pool.channel.should == 3
  end
  
end
