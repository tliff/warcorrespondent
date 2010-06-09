module WarCorrespondent
  module Reporters
    module Linux
      class LoadAvg < WarCorrespondent::Reporter
        def initialize(args)
        
          @block = Proc.new do
            load = SystemInformation::load
            [
              {:identifier => "load:1", :type => "float", :value => load[:load_1]},
              {:identifier => "load:5", :type => "float", :value => load[:load_5]},
              {:identifier => "load:15", :type => "float", :value => load[:load_15]},
              {:identifier => "processes:running", :type => "integer", :value => load[:procs_running]},
              {:identifier => "processes:total", :type => "integer", :value => load[:procs_total]}
            ]
          end
          super(args)
        end
      end
    end
  end
end
