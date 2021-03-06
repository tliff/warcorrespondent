module WarCorrespondent
  class Reporter
    attr_accessor :timeout
    attr_accessor :identifier
    attr_accessor :options
    
    def initialize(args, &block)
      @timeout = 300
      [:timeout, :identifier, :options].each do |key|
        if args[key] && self.respond_to?("#{key}=")
          self.send("#{key}=",args[key])
        end
      end
      @block = block if block
      WarCorrespondent::register_reporter(self)
    end

    def update
      Logging::logger.debug{"Updating #{@identifier}"}
      data = instance_eval(&@block)
      return if data == nil
      data = [data] if data.class == Hash
      data.map! do |e|
        e = {:timestamp => Time.now.to_i}.merge(e)
        e[:identifier] = identifier + (e[:identifier]  ? (':' + e[:identifier]) : '')
        e[:identifier].gsub!(/:+/, ':')
        e
      end
      WarCorrespondent::update(data)
    rescue Exception => e
      Logging::logger.warn{e}
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

Dir.glob(File.dirname(__FILE__) + "/reporters/*.rb") do |i|
  require i
end