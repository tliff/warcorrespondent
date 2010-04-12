module WarCorrespondent
  module Reporters
    class UsersReporter < WarCorrespondent::Reporter
      def initialize(args)
        
        @block = Proc.new do
          count = 0
          IO.popen('who') do |p|
            count = p.readlines.size
          end
          {:value => count, :type => "integer" }
        end
        
        super(args)
      end
    end
  end
end 