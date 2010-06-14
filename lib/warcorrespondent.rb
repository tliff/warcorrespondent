require 'warcorrespondent/reporter.rb'
require 'warcorrespondent/uplink.rb'
require 'warcorrespondent/installer.rb'
require 'json'
require 'systeminformation'
require 'yaml'

module WarCorrespondent
  CONFIG_FILE = '/etc/warcorrespondent/warcorrespondent.yml'
  REPORTERS_DIRECTORIES = '/etc/warcorrespondent/reporters'

  def config_base_directory
    [ '/etc/warcorrespondent',
      '~/.warcorrespondent',
      '.'].each do |f|
        return f if File.exists?(f)
      end
  end
  
  def reporters_directory
    REPORTERS_DIRECTORIES
  end
  
  def config_file

  end

  def self.setup
    @@reporters ||= []
    @@uplink = Uplink.new
    begin
      @@config = YAML.load_file(config_file)
      @@uplink.url = @@config['url']
      @@uplink.secret = @@config['secret']
    rescue
      raise "Could not load config file #{config_file}"
      exit
    end
    Dir.glob("#{reporters_directory}/*.rb").each do |i| 
      begin
        require i 
      rescue
        puts "Parse error in #{i}. Bailing out."
      end
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
