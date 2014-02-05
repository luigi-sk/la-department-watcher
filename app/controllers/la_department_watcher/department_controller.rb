require_dependency "la_department_watcher/application_controller"

module LaDepartmentWatcher
  class DepartmentController < ApplicationController
    def watch
      proceed = false
      minute_cache = "#{Rails.root}/tmp/DepartmentController_watch"
      FileUtils.touch(minute_cache) unless File.exists?(minute_cache)
      if (DateTime.now().to_i - File.atime(minute_cache).to_i).abs > 30
        LaDepartmentWatcher::Watcher.watch
        FileUtils.touch(minute_cache)
        proceed = true
      end

      respond_to do |format|
        format.json { render json: { proceed: proceed }}
      end
    end
  end
end
