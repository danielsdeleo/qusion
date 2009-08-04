# encoding: UTF-8

module AMQP
  def self.start_web_dispatcher(*args)
    if defined?(PhusionPassenger) 
      PhusionPassenger.on_event(:starting_worker_process) do |forked| 
        if forked
          EM.kill_reactor
          Thread.current[:mq] = nil 
          @conn = nil
        end 
        th = Thread.current 
        Thread.new do
          self.start(*args) 
        end
        die_gracefully_on_signal
      end
    elsif defined?(::Thin)
      @settings = settings.merge(*args)
      die_gracefully_on_signal
    elsif defined?(::Mongrel)
      th = Thread.current 
      Thread.new do
        self.start(*args) 
      end
      die_gracefully_on_signal
    else
      puts "=> Qusion did not find a supported app server (This is normal for workling workers)"
    end
  end
  
  def self.die_gracefully_on_signal
    Signal.trap("INT") { AMQP.stop { EM.stop } }
    Signal.trap("TERM") { AMQP.stop { EM.stop } }
  end
end
