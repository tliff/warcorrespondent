require 'warcorrespondent/logging.rb'
require 'warcorrespondent/reporter.rb'
require 'warcorrespondent/uplink.rb'
require 'warcorrespondent/installer.rb'
require 'json'
require 'systeminformation'
require 'yaml'

module WarCorrespondent
  def self.config_base_directory
    [ '/etc/warcorrespondent', '~/.warcorrespondent'].each do |f|
      if File.exists?(File.expand_path(f))
        return File.expand_path(f)
      end
    end
    nil
  end

  def self.config_file
    config_base_directory+"/warcorrespondent.yml" if config_base_directory
  end
  
  def self.reporters_directory
    config_base_directory+"/reporters" if config_base_directory
  end
  
  def self.log_file
    '/var/log/warcorrespondent'
  end

  def self.setup
    @@reporters ||= []
    @@uplink = Uplink.new
    begin
      @@config = YAML.load_file(config_file)
      @@uplink.url = @@config['url']
      @@uplink.secret = @@config['secret']
    rescue
      Logging::logger.fatal "Could not load config file #{config_file}. Bailing out."
      exit
    end
    Dir.glob("#{reporters_directory}/*.rb").each do |i| 
      begin
        Logging::logger.info "including #{i}"
        require i 
      rescue
        Logging::logger.fatal "Parse error in #{i}. Bailing out."
      end
    end
  end
  
  def self.run
    pp self.methods
    Logging::logger.info{'warcorrespondent starting up'}
    setup
    Logging::logger.debug "config loaded..."
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
