module LaDepartmentWatcher
  module Watcher
    def self.watch
      LaDepartmentWatcher::Config.get.config[:departments].each do |name, options|
        Rails.logger.info("Check department #{name}")
        departmentid = options['departmentid']
        find_for_status = options['online_statuses'].downcase.split(",")
        department_api = DepartmentApi.find(departmentid)
        department = Department.find_by_department(department_api)
        online_channels = find_for_status & department.onlinestatus.to_s.downcase.split(//)
        status_alert_find = online_channels.size == 0
        if status_alert_find
          # alert status is found
          if department.ok? # start alert if department ok
            Event.start_alert(department)
          else
            DepartmentMailer.notify_alert(department) if department.last_alert.email_alert?
          end
        else
          # alert status isn't found
          Event.end_alert(department) unless department.ok?
        end
      end
    end

  end
end