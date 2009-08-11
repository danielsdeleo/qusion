# encoding: UTF-8

module AMQP
  def self.start_web_dispatcher(amqp_settings={})
    @settings = settings.merge(amqp_settings)
    case Qusion::ServerSpy.server_type
    when :passenger
      PhusionPassenger.on_event(:starting_worker_process) do |forked| 
        if forked
          EM.kill_reactor
          Thread.current[:mq], @conn = nil, nil
        end 
        Thread.new { self.start }
        die_gracefully_on_signal
      end
    when :standard
      Thread.new { self.start }
      die_gracefully_on_signal
    when :evented
      die_gracefully_on_signal
    when :none
    else
      raise ArgumentError, "AMQP#start_web_dispatcher requires an argument of [:standard|:evented|:passenger|:none]"
    end
  end
  
  def self.die_gracefully_on_signal
    Signal.trap("INT") { AMQP.stop { EM.stop } }
    Signal.trap("TERM") { AMQP.stop { EM.stop } }
  end
end
