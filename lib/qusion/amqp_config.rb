# encoding: UTF-8

module Qusion
  
  class AmqpConfig
    attr_reader :config_path, :framework_env
    
    def initialize(opts=nil)
      if opts && opts.respond_to?(:keys)
        @config_path = nil
        @config_opts = opts
      elsif opts
        @config_path = opts
      else
        load_framework_config
      end
    end
    
    def load_framework_config
      if defined?(RAILS_ROOT)
        @config_path = RAILS_ROOT + "/config/amqp.yml"
        @framework_env = RAILS_ENV
      elsif defined?(Merb)
        @config_path = Merb.root + "/config/amqp.yml"
        @framework_env = Merb.environment
      else
        nil
      end
    end
    
    def config_opts
      @config_opts ||= load_config_opts
    end
    
    def load_config_opts
      if config_path && framework_env
        load_framework_amqp_opts_file
      elsif config_path
        load_amqp_opts_file
      else
        {}
      end
    end
    
    def load_framework_amqp_opts_file
      opts = {}
      YAML.load_file(config_path)[framework_env.to_s].each do |option, value|
        opts[option.to_sym] = value
      end
      opts
    end
    
    def load_amqp_opts_file
      opts = {}
      YAML.load_file(config_path).first.last.each do |option, value|
        opts[option.to_sym] = value
      end
      opts
    end
    
  end
end
