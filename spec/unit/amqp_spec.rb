# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe AMQP do
  
  after(:each) do
    Object.send(:remove_const, :PhusionPassenger) if defined? PhusionPassenger
    Object.send(:remove_const, :Thin) if defined? Thin
  end
  
  it "should kill the reactor and start a new AMQP connection when forked in Passenger" do
    AMQP.should_receive(:die_gracefully_on_signal)
    PhusionPassenger = Object.new
    forked = mock("starting_worker_process_callback_obj")
    PhusionPassenger.should_receive(:on_event).with(:starting_worker_process).and_yield(forked)
    EM.should_receive(:kill_reactor)
    AMQP.should_receive(:start)
    AMQP.start_web_dispatcher
  end
  
  it "should set AMQP's connection settings when running under Thin" do
    AMQP.should_receive(:die_gracefully_on_signal)
    Thin = Object.new
    AMQP.stub!(:settings).and_return({})
    AMQP.start_web_dispatcher({:cookie => "yummy"})
    AMQP.instance_variable_get(:@settings)[:cookie].should == "yummy"
  end
  
  it "should start a worker thread when running under other web/app servers" do
    AMQP.should_receive(:die_gracefully_on_signal)
    AMQP.should_receive(:start)
    AMQP.start_web_dispatcher
  end
  
end
