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
      @block = block if block
      WarCorrespondent::register_reporter(self)
    end

    def update
      data = @block.call
      data = [data] if data.class == Hash
      data.map! do |e|
        e[:identifier] = "#{identifier}#{e[:identifier] ? (':' + e[:identifier]) : ''}".gsub(/:+/, ':')
        e
      end
      WarCorrespondent::update({:payload => data, :timestamp => Time.now.to_i})
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
puts Dir.pwd
Dir.glob(File.dirname(__FILE__) + "/reporters/*.rb") do |i| 
  require i 
end