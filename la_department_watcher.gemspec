$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "la_department_watcher/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "la_department_watcher"
  s.version     = LaDepartmentWatcher::VERSION
  s.authors     = ["Lukas Votypka"]
  s.email       = ["admin@chat-support.net"]
  s.homepage    = "http://needagents.com"
  s.summary     = "Development"
  s.description = "Client to watching availability of departments on ladesk sw."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.16"
  s.add_dependency 'httparty'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
end
