require 'warcorrespondent/reporter.rb'
require 'warcorrespondent/uplink.rb'
require 'json'
require 'systeminformation'
require 'yaml'

module WarCorrespondent
  CONFIG_FILE = '/etc/warcorrespondent/warcorrespondent.yml'
  REPORTERS_DIRECTORIES = '/etc/warcorrespondent/reporters'

  def config_file
    [ 'warcorrespondent.yml'
      '/etc/warcorrespondent/warcorrespondent.yml',
      '~/.warcorrespondent/warcorrespondent.yml'].each do |f|
        return f if File.exists?(f)
      end
  end
  
  def install
    puts <<-EOT
    warcorrespondent could not find your config file and will now guide you
    through the setup process.
    
    Do you want to install system-wide (1) or in your home directory(2)? [1]
    EOT
    basepath = nil
    while cmd = gets.strip && ['1', '2', ''].member?(cmd) do end
    if cmd == '1' || cmd == '' do
      basepath = '/etc/warcorrespondent'
    elsif cmd == '2'
      basepath = '~/.warcorrespondent'
    end
    #create the directory if necessary
    if !File.exists?(basepath) then Dir.mkdir(basepath) end
    if !File.exists?(basepath+"/reporters") then Dir.mkdir(basepath+"/reporters") end
    config = {}
    puts <<-EOT
      Where do you want warcorrespondent to report to?
      If you want to report to warroom, just press enter [http://warroom.tliff.de/reports]
    EOT
    url = gets.strip
    config[:url] = url.empty? ? "http://warroom.tliff.de/reports" : url
    puts <<-EOT
      What is the secret this warcorrespondent instance will
      use to authenticate to warroom?
    EOT
    while config[:secret] = gets.strip && config[:secret].empty? do end
    File.open( "#{basepath}/warcorrespondent.yml", 'w+' ) do |f|
      YAML.dump(config, f)
    end
    
    puts <<-EOT
    warcorrespondent can now set up basic reporting for this host.
    Would you like to have that set up for you(y/n)[y]?
    EOT
    while cmd = gets.strip && ['y', 'n', ''].member?(cmd) do end
    if cmd == 'y' || cmd == '' do
      hostname = `hostname`
      basic = <<-EOT
      WarCorrespondent::Reporters::CPU.new(:identifier => 'hosts:#{hostname}:stats')
      WarCorrespondent::Reporters::LoadAvg.new(:identifier => 'hosts:#{hostname}:stats')
      WarCorrespondent::Reporters::Memory.new(:identifier => 'hosts:#{hostname}:stats')
      WarCorrespondent::Reporters::Net.new(:identifier => 'hosts:#{hostname}:stats')
      EOT
      File.new("#{basepath}/reporters/basic.rb", "w+") do |f|
        f.write(basic)
      end
    end
    
    puts <<-EOT
    Setup is now complete.
    EOT
    
  end
  
  def self.setup
    @@reporters ||= []
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
