# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe EM do
  
  it "should kill the reactor for forking" do
    EM.should_receive(:reactor_running?).and_return(true)
    EM.should_receive(:stop_event_loop)
    EM.should_receive(:release_machine)
    EM.kill_reactor
    EM.instance_variable_get(:@reactor_running).should be_false
  end
  
end
