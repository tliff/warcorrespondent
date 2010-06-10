module WarCorrespondent
  module Reporters
    class Net < WarCorrespondent::Reporter
      def initialize(args)
        @block = Proc.new do
          SystemInformation::net.map{ |net_id,data|
            data.map{ |type, value|
              {:identifier => "net:#{net_id.to_s}:#{type.to_s}", :value => value }
            }
          }.inject([]){|a,b|a+b}
        end
        super(args)
      end
    end
  end
end
