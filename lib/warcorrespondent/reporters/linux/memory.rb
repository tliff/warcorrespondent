module WarCorrespondent
  module Reporters
    module Linux
      class Memory < WarCorrespondent::Reporter
        def initialize(args)
          @block = Proc.new do
            items = {
              'mem:free' => 'MemFree',
              'mem:cached' => 'Cached',
              'mem:buffers' => 'Buffers',
              'mem:total' => 'MemTotal',
              'swap:total' => 'SwapTotal',
              'swap:free' => 'SwapFree'
              
            }
            File.open('/proc/meminfo','r') do |f|
              f.readlines.each do |l|
                items.each_pair do |i, k|
                  if matches = Regexp.new("#{k}: +([0-9]+)").match(l)
                    items[i] = matches[1].to_i
                  end
                end
              end
              items['mem:used'] = items['mem:total'] - items['mem:free'] - items['mem:cached'] - items['mem:buffers']
              items['swap:used'] = items['mem:total'] - items['mem:free']
            end
            items.map{|k,v|
              {:identifier => k, :value => v, :type => "integer", :unit => "kB"}
            }
          end
          super(args)
        end
      end
    end
  end
end