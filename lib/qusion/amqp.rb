# encoding: UTF-8

module AMQP
  def self.start_web_dispatcher(*args)
    p "web worker args: #{args.inspect}"
    if defined?(PhusionPassenger) 
      PhusionPassenger.on_event(:starting_worker_process) do |forked| 
        if forked
          EM.kill_reactor
          Thread.current[:mq] = nil 
          @conn = nil
        end 
        th = Thread.current 
        Thread.new{ 
          self.start(*args) 
        } 
      end
    elsif defined?(::Thin)
      @settings = settings.merge(*args)
    else
      th = Thread.current 
      Thread.new{ 
        self.start(*args) 
      } 
    end
  end
end
