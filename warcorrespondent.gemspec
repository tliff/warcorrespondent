# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{warcorrespondent}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Maier"]
  s.date = %q{2010-06-09}
  s.default_executable = %q{warcorrespondent}
  s.description = %q{warcorrespondent collects data and reports it back to warroom.}
  s.email = %q{stefanmaier@gmail.com}
  s.executables = ["warcorrespondent"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/warcorrespondent",
     "lib/warcorrespondent.rb",
     "lib/warcorrespondent/reporter.rb",
     "lib/warcorrespondent/reporters/cpu.rb",
     "lib/warcorrespondent/reporters/loadavg.rb",
     "lib/warcorrespondent/reporters/memory.rb",
     "lib/warcorrespondent/reporters/net.rb",
     "lib/warcorrespondent/reporters/users.rb",
     "lib/warcorrespondent/uplink.rb"
  ]
  s.homepage = %q{http://github.com/tliff/warcorrespondent}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{warcorrespondent reports to the warroom.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<daemons>, [">= 0"])
      s.add_runtime_dependency(%q<systeminformation>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<daemons>, [">= 0"])
      s.add_dependency(%q<systeminformation>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<daemons>, [">= 0"])
    s.add_dependency(%q<systeminformation>, [">= 0"])
  end
end

