# encoding: UTF-8

module EM
  
  def self.kill_reactor
    if self.reactor_running? 
      self.stop_event_loop 
      self.release_machine 
      @reactor_running = false
    end 
  end
  
end
