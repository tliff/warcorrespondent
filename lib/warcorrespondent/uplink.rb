require 'net/http'
module WarCorrespondent
  class Uplink
    
    attr_accessor :url
    attr_accessor :secret
    
    def initialize
      @@messages = []
    end

    def add(message)
      @@messages << message
    end

    def sync
      return if @@messages.size == 0
      buffer = []
      10.times do
        buffer << @@messages.shift if @@messages.size > 0
      end
      buffer.each do |message| 
        begin
          post(encode(message))
        rescue
          add(message)
        end
      end
    end
    
    def run
      loop do
        sync
        sleep 1
      end
    end

    private
    
    def encode(message)
      message.to_json
    end
    
    def post(message)
      res = Net::HTTP.post_form(URI.parse(url), {'secret'=>secret, 'data'=>message})
    end
    
  end
end
