# LiveAgent department watcher

This is an application to detect if department of LiveAgent(ladesk.com) is online. If the department is offline( not available on chat and phone), then application sent an email notification.

### Instalation
 
 la-department-watcher is a rails engine. Install it with Bundler in your Gemfile.
 
 ```ruby
 gem 'la-department-watcher', :git => 'git://github.com/luigi-sk/la-department-watcher.git'
 ```
 
 ```sh
 bundle install
 rake la_department_watcher:install:migrations
 rake db:migrate
 ```
 
 Your LiveAgent department and apikey is defined by `config/la.yml`.
 
 ----
 
 Copyright &copy; 2014 Lukas Votypka
 
 
