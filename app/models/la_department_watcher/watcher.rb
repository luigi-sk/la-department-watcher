module LaDepartmentWatcher
  module Watcher
    def self.watch
      LaDepartmentWatcher::Config.get.config[:departments].each do |name, options|
        Rails.logger.info("Check department #{name}")
        departmentid = options['departmentid']
        find_for_status = options['warning_statuses'].split(",")
        department_api = DepartmentApi.find(departmentid)
        department = Department.find_by_department(department_api)
        status_alert_find = false
        find_for_status.each { |s| status_alert_find = true if department.onlinestatus.include?(s) }
        if status_alert_find && department.ok?
          Event.start_alert(department)
        elsif !status_alert_find && !department.ok?
          Event.end_alert(department)
        end
      end
    end

    def alert_is_open?(department)
      last = Department.find_last_by_departmentid(department['departmentid'])
      if last.new_record?
        Department.create_from_department_api(department)
        return false
      end



    end
  end
end