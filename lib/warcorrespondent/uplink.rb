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
      begin
        message = @@messages.shift
        post(encode(message))
      rescue
        add(message)
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
      res = Net::HTTP.post_form(URI.parse(url),
                                {'secret'=>secret, 'data'=>message})
      raise if res.code == 200
    end
    
  end
end