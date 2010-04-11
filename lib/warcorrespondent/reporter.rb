module WarCorrespondent
  class Reporter
    attr_accessor :timeout
    attr_accessor :identifier
    def initialize(args, &block)
      @timeout = 5
      [:timeout, :identifier].each do |key|
        if args[key] && self.respond_to?("#{key}=")
           self.send("#{key}=",args[key])
         end
      end
      @block = block
      WarCorrespondent::register_reporter(self)
    end

    def update
      WarCorrespondent::update({:payload => @block.call, :identifier => identifier, :timestamp => Time.now.to_i})
    end

    def run
      loop do
        update
        sleep timeout
      end
    end
    
    private

  end
  
end