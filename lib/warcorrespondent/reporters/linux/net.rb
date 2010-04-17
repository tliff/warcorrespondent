module WarCorrespondent
  module Reporters
    module Linux
      class Net < WarCorrespondent::Reporter
        def initialize(args)
          @block = Proc.new do
            get_data = Proc.new do
              delta = nil
              data = {}
              File.open('/proc/net/dev','r') do |f|
                f.readlines.select{|l| l =~ /:/}.each do |l|
                  l.gsub!(/ +/,' ').strip!
                  id, body = l.split(':')
                  body = body.strip.split
                  data[id] = [body[0],body[1],body[8],body[9]]
                end
              end
              data
            end
            if !@prev_data
              @prev_data = get_data.call
              delta = 5
              sleep 5
            end
            delta ||= timeout
            @new_data = get_data.call
            difference ={}
            @prev_data.keys.each{|k|
              difference[k] = @prev_data[k].zip(@new_data[k]).map{|i| (i[1].to_f - i[0].to_f)/delta}
            }
            @prev_data = @new_data
            result=[]
            difference.each{|k,body|
              result << {:identifier => "net:#{k}:rbytes", :value => body[0], :type => "integer"}
              result << {:identifier => "net:#{k}:rpackets", :value => body[1], :type => "integer"}
              result << {:identifier => "net:#{k}:sbytes", :value => body[2], :type => "integer"}
              result << {:identifier => "net:#{k}:spackets", :value => body[3], :type => "integer"}
            }
            result
          end
          super(args)
        end
      end
    end
  end
end