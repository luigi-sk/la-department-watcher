module LaDepartmentWatcher
  module Watcher
    def self.watch
      LaDepartmentWatcher::Config.get.config[:departments].each do |name, options|
        Rails.logger.info("Check department #{name}")
        departmentid = options['departmentid']
        find_for_status = options['online_statuses'].downcase.split(",")
        department_api = DepartmentApi.find(departmentid)
        send_and_notify(department_api, find_for_status)
      end
    end

    # ==== Example
    #     It returns one from results
    #        :start_alert - start alert
    #        :alert - while alert is opened and nothing is changed
    #        :notify - email notification was send
    #        :end_alert - alert was closed
    #        nil - nothing happend
    #
    # @param [Hash] department_api
    # @param [Array<String>] online_statuses
    # @return [Symbol]
    def self.save_and_notify(department_api, online_statuses)
      result = nil
      online_statuses = online_statuses.map { |i| i.downcase }
      department = Department.find_by_department(department_api)
      department_statuses = department.onlinestatus.to_s.downcase.split(//)
      online_channels = online_statuses & department_statuses
      status_alert_find = online_channels.size == 0 && online_statuses.size > 0
      if status_alert_find
        result = :alert
        # alert status is found
        if department.ok? # start alert if department ok
          Event.start_alert(department)
          result = :start_alert
        else
          if department.last_alert.email_alert?
            DepartmentMailer.notify_alert(department)
            result = :notify
          end
        end
      else
        # alert status isn't found
        unless department.ok?
          Event.end_alert(department)
          result = :end_alert
        end
      end
      result
    end

  end
end