# encoding: UTF-8
require File.dirname(__FILE__) + "/../spec_helper"

describe AmqpConfig do
  
  after(:each) do
    Object.send(:remove_const, :RAILS_ROOT) if defined? RAILS_ROOT
    Object.send(:remove_const, :Merb) if defined? Merb
  end
  
  it "should use RAILS_ROOT/config/amqp.yml if RAILS_ROOT is defined" do
    RAILS_ROOT = "/path/to/rails"
    RAILS_ENV = nil
    AmqpConfig.new.config_path.should == "/path/to/rails/config/amqp.yml"
  end
  
  it "should use \#{Merb.root}/config/amqp.yml if RAILS_ROOT is undefined and Merb is defined" do
    Merb = mock("merby")
    Merb.should_receive(:root).and_return("/path/to/merb")
    Merb.should_receive(:environment).and_return(nil)
    AmqpConfig.new.config_path.should == "/path/to/merb/config/amqp.yml"
  end
  
  it "should use the provided path no matter what" do
    RAILS_ROOT = nil
    Merb = nil
    path = AmqpConfig.new("/custom/path/to/amqp.yml").config_path
    path.should == "/custom/path/to/amqp.yml"
  end
  
  it "should use a provided options hash if given" do
    RAILS_ROOT = nil
    Merb = nil
    conf = AmqpConfig.new(:host => "my-broker.mydomain.com")
    conf.config_path.should be_nil
    conf.config_opts.should == {:host => "my-broker.mydomain.com"}
  end
  
  it "should use the default amqp options in rails if amqp.yml doesn't exist" do
    RAILS_ROOT = File.dirname(__FILE__) + '/../'
    AmqpConfig.new.config_opts.should == {}
  end
  
  it "should load a YAML file when using a framework" do
    conf = AmqpConfig.new
    conf.stub!(:config_path).and_return(File.dirname(__FILE__) + "/../fixtures/framework-amqp.yml")
    conf.stub!(:framework_env).and_return("production")
    conf.config_opts.should == {:host => 'localhost',:port => 5672,
                                :user => 'guest', :pass => 'guest',
                                :vhost => '/', :timeout => 3600,
                                :logging => false, :ssl => false}
  end
  
  it "should use the first set of opts when given a explicit file path" do
    conf = AmqpConfig.new
    conf.stub!(:config_path).and_return(File.dirname(__FILE__) + "/../fixtures/hardcoded-amqp.yml")
    conf.config_opts.should == {:host => 'localhost',:port => 5672,
                                :user => 'guest', :pass => 'guest',
                                :vhost => '/', :timeout => 600,
                                :logging => false, :ssl => false}
  end
  
end
