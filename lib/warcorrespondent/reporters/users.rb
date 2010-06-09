module WarCorrespondent
  module Reporters
    class UsersReporter < WarCorrespondent::Reporter
      def initialize(args)
        
        @block = Proc.new do
          {:identifier => "users", :value => SystemInformation::users }
        end
        
        super(args)
      end
    end
  end
end 