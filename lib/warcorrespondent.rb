require 'warcorrespondent/reporter.rb'
require 'warcorrespondent/uplink.rb'
require 'json'
require 'yaml'

module WarCorrespondent
  CONFIG_FILE = '/etc/warcorrespondent/warcorrespondent.yml'
  REPORTERS_DIRECTORIES = '/etc/warcorrespondent/reporters'
  
  def self.setup
    @@uplink = Uplink.new
    begin
      @@config = YAML.load_file(CONFIG_FILE)
      @@uplink.url = @@config['url']
      @@uplink.secret = @@config['secret']
    rescue
      raise "Could not load config file #{CONFIG_FILE}"
      exit
    end
    Dir.glob("#{REPORTERS_DIRECTORIES}/*.rb").each do |i| 
      require i 
    end
  end
  
  def self.run
    Thread.new do 
      @@uplink.run
    end
    @@reporters.each do |reporter|
      Thread.new do
        reporter.run
      end
    end
    loop do
      sleep 1
    end
  end
  
  def self.register_reporter(reporter)
    @@reporters ||= []
    @@reporters << reporter
  end
  
  def self.update(message)
    @@uplink.add(message)
  end
end