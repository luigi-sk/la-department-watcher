# LiveAgent department watcher

This is an application to detect if department of LiveAgent(ladesk.com) is online. If the department is offline( not available on chat and phone), then application sent an email notification.

### Installation
 
 LaDepartmentWatcher is a rails engine. Install it with Bundler in your Gemfile.
 
 ```ruby
 # Gemfile
 gem 'la_department_watcher', :git => 'git://github.com/luigi-sk/la-department-watcher.git'
 ```
 
 ```sh
 bundle install
 rake la_department_watcher:install:migrations
 rake db:migrate
 ```
 
 Mount an engine on `config/routes.rb`.
 ```ruby
 # config/routes.rb
 mount LaDepartmentWatcher::Engine, at: "/ladesk"
 ```
 
 Setup cronjob to call `curl 'http://you-application-host/ladesk/department/watch.json'` every minute
 
 
 Your LiveAgent department and apikey is defined by `config/la.yml`.
 
 ----
 
 Copyright &copy; 2014 Lukas Votypka
 
 
