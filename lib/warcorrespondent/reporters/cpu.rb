module WarCorrespondent
  module Reporters
    module Linux
      class CPU < WarCorrespondent::Reporter
        def initialize(args)
          @block = Proc.new do
            SystemInformation::cpu.map{ |cpu_id,data|
              data.map{ |type, value|
                {:identifier => "cpu:#{cpu_id.to_s}:#{type.to_s}", :value => value }
              }.inject([])(&:key => "value", +)
            }
          end
          super(args)
        end
      end
    end
  end
end