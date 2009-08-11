# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe ServerSpy do
  
  after do
    Object.send(:remove_const, :SCGI) if defined? SCGI
    Object.send(:remove_const, :WEBrick) if defined? WEBrick
    Object.send(:remove_const, :PhusionPassenger) if defined? PhusionPassenger
    Object.send(:remove_const, :Thin) if defined? Thin
    Mongrel.send(:remove_const, :MongrelProtocol) if defined?(Mongrel::MongrelProtocol)
    Object.send(:remove_const, :Mongrel) if defined? Mongrel
  end
  
  it "maps evented mongrel to :evented" do
    Mongrel = Module.new
    Mongrel::MongrelProtocol = Object.new
    ServerSpy.server_type.should == :evented
  end
  
  it "maps Mongrel to :standard" do
    Mongrel = Object.new
    ServerSpy.server_type.should == :standard
  end
  
  it "maps WEBrick to :standard" do
    WEBrick = Object.new
    ServerSpy.server_type.should == :standard
  end
  
  it "maps SCGI to :standard" do
    SCGI = Object.new
    ServerSpy.server_type.should == :standard
  end
  
  it "maps PhusionPassenger to :passenger" do
    PhusionPassenger = Object.new
    ServerSpy.server_type.should == :passenger
  end
  
  it "maps Thin to :evented" do
    Thin = Object.new
    ServerSpy.server_type.should == :evented
  end
  
  # Rails after 2.2(?) to edge circa Aug 2009 loads thin if it's installed no matter what
  it "gives the server type as :standard if both Thin and Mongrel are defined" do
    Mongrel = Object.new
    Thin = Object.new
    ServerSpy.server_type.should == :standard
  end
  
  it "gives the server type as :passenger if both Thin and PhusionPassenger" do
    PhusionPassenger = Object.new
    Thin = Object.new
    ServerSpy.server_type.should == :passenger
  end
  
  it "gives the server type as :none if no supported server is found" do
    ServerSpy.server_type.should == :none
  end
  
end
