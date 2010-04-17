module WarCorrespondent
  module Reporters
    module Linux
      class CPU < WarCorrespondent::Reporter
        def initialize(args)
          @block = Proc.new do
            get_data = Proc.new do
              data = nil
              File.open('/proc/stat','r') do |f|
                f.readlines.select{|l| l =~ /^cpu /}.each do |l|
                  data = l.split
                  data.shift
                end
              end
              data
            end
            if !@prev_data 
              @prev_data = get_data.call
              sleep 5
            end
            @new_data = get_data.call
            difference = @prev_data.zip(@new_data).map{|i| i[1].to_f - i[0].to_f}
            sum = difference.inject{|a,b| a+b}
            difference.map!{|i| i/sum}
            @prev_data = @new_data
            [
              {:identifier => "cpu:user", :type => "float", :value => difference[0]},
              {:identifier => "cpu:nice", :type => "float", :value => difference[1]},
              {:identifier => "cpu:system", :type => "float", :value => difference[2]},
              {:identifier => "cpu:idle", :type => "float", :value => difference[3]},
              {:identifier => "cpu:running", :type => "float", :value => difference[4]},
              {:identifier => "cpu:iowait", :type => "float", :value => difference[5]},
              {:identifier => "cpu:irq", :type => "float", :value => difference[6]},
              {:identifier => "cpu:softirq", :type => "float", :value => difference[7]}
            ]
          end
          super(args)
        end
      end
    end
  end
end