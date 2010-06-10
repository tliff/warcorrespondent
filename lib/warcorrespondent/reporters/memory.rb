module WarCorrespondent
  module Reporters
    class Memory < WarCorrespondent::Reporter
      def initialize(args)
        @block = Proc.new do
          mem_items = {:free => :free, :cached => :cached, :buffers => :buffers, :total => :total, :used => :used}
          swap_items = {:swaptotal => :total, :swapfree => :free, :swapused => :used}
          memory = SystemInformation::memory
          mem_items = mem_items.map{|k,v| {:identifier => "mem:#{v.to_s}", :value => memory[k]}}
          swap_items = swap_items.map{|k,v| {:identifier => "swap:#{v.to_s}", :value => memory[k]}}
          mem_items + swap_items
        end
        super(args)
      end
    end
  end
end
