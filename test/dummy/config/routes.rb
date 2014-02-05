Rails.application.routes.draw do

  mount LaDepartmentWatcher::Engine => "/la_department_watcher"
end
