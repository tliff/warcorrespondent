module WarCorrespondent
  module Reporters
    module Linux
      class LoadAvg < WarCorrespondent::Reporter
        def initialize(args)
        
          @block = Proc.new do
            File.open('/proc/loadavg','r') do |f|
              line = f.readline
              load_one_min, load_five_min, load_fivteen_min, processes = line.split
              processes_running, processes_total = processes.split('/')
              [
                {:identifier => "load:1", :type => "float", :value => load_one_min},
                {:identifier => "load:5", :type => "float", :value => load_five_min},
                {:identifier => "load:15", :type => "float", :value => load_fivteen_min},
                {:identifier => "processes:running", :type => "integer", :value => processes_running},
                {:identifier => "processes:total", :type => "integer", :value => processes_total}
              ]
            end
          end
          super(args)
        end
      end
    end
  end
end