module WarCorrespondent
  module Reporters
    class LoadAvg < WarCorrespondent::Reporter
      def initialize(args)
        @block = Proc.new do
          load = SystemInformation::load
          [
            {:identifier => "load:1", :value => load[:load_1]},
            {:identifier => "load:5", :value => load[:load_5]},
            {:identifier => "load:15", :value => load[:load_15]},
            {:identifier => "processes:running", :value => load[:procs_running]},
            {:identifier => "processes:total", :value => load[:procs_total]}
          ]
        end
        super(args)
      end
    end
  end
end
