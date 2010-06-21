require 'logger'
require 'singleton'
module WarCorrespondent 
  class WLogger  < Logger
    include Singleton
    def initialize
      super(WarCorrespondent::log_file,10, 10_000_000)
    end
  end

  module Logging
    def self.logger
      @logger_instance ||= WLogger.instance
    end
    def logger
      self.logger
    end
  end

end
