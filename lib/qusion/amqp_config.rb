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
      if config_path && config_from_yaml = load_amqp_config_file
        if framework_env
          framework_amqp_opts(config_from_yaml)
        else
          amqp_opts(config_from_yaml)
        end
      else
        {}
      end
    end
    
    def framework_amqp_opts(config_hash)
      symbolize_keys(config_hash[framework_env.to_s])
    end
    
    def amqp_opts(config_hash)
      symbolize_keys(config_hash.first.last)
    end
    
    def symbolize_keys(config_hash)
      symbolized_hsh = {}
      config_hash.each {|option, value| symbolized_hsh[option.to_sym] = value }
      symbolized_hsh
    end
    
    def load_amqp_config_file
      begin
        YAML.load_file(config_path)
      rescue Errno::ENOENT
      end
    end
    
  end
end
