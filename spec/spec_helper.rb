# encoding: UTF-8
require 'rubygems'

require File.dirname(__FILE__) + '/../lib/qusion.rb'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

include Qusion

