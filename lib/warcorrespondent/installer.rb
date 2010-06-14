module WarCorrespondent
  module Installer
    
    TEXT_INTRO = <<-EOT
warcorrespondent could not find your config file and will now guide you
through the setup process.

Do you want to install system-wide (1) or in your home directory(2)? [1]
EOT

    TEXT_TARGET = <<-EOT
Where do you want warcorrespondent to report to?
If you want to report to warroom, just press enter [http://warroom.tliff.de/reports]
EOT

    TEXT_SECRET = <<-EOT
What is the secret this warcorrespondent instance will
use to authenticate to warroom?
EOT

    TEXT_BASIC_SETUP = <<-EOT
warcorrespondent can now set up basic reporting for this host.
Would you like to have that set up for you(y/n)[y]?
EOT

    TEXT_TEMPLATE = <<-EOT
WarCorrespondent::Reporters::CPU.new(:identifier => 'hosts:@@HOST@@:stats')
WarCorrespondent::Reporters::LoadAvg.new(:identifier => 'hosts::@@HOST@@:stats')
WarCorrespondent::Reporters::Memory.new(:identifier => 'hosts::@@HOST@@:stats')
WarCorrespondent::Reporters::Net.new(:identifier => 'hosts::@@HOST@@:stats')
EOT

    TEXT_DONE = <<-EOT
Setup is now complete.
EOT


    def self.install
      puts TEXT_INTRO
      basepath = nil
      while (cmd = gets.strip) && !['1', '2', ''].member?(cmd) do end
      if cmd == '1' || cmd == '' then
        basepath = '/etc/warcorrespondent'
      elsif cmd == '2'
        basepath = File.expand_path('~/.warcorrespondent')
      end
      #create the directory if necessary
      if !File.exists?(basepath) then Dir.mkdir(basepath) end
      if !File.exists?(basepath+"/reporters") then Dir.mkdir(basepath+"/reporters") end
      config = {}
      puts TEXT_TARGET
      url = gets.strip
      config['url'] = url.empty? ? "http://warroom.tliff.de/reports" : url
      puts TEXT_SECRET
      while (config['secret'] = gets.strip) && config['secret'].empty? do end
      File.open( "#{basepath}/warcorrespondent.yml", 'w+' ) do |f|
        YAML.dump(config, f)
      end

      puts TEXT_BASIC_SETUP
      while (cmd = gets.strip) && !['y', 'n', ''].member?(cmd) do end
      if cmd == 'y' || cmd == '' then
        hostname = `hostname`.strip

        File.open("#{basepath}/reporters/basic.rb", "w+") do |f|
          f.write(TEXT_TEMPLATE.gsub(/@@HOST@@/, hostname))
        end
      end

      puts TEXT_DONE

    end    
  end
end
