module LaDepartmentWatcher
  module Watcher

    # sync all departments from config
    def self.sync
      LaDepartmentWatcher::Config.get.config[:departments].each do |name, options|
        # sync department
        department_api = DepartmentApi.find(options['departmentid'])
        Department.find_by_department(department_api)
      end
    end

    def self.watch
      # synchronize with api
      sync
      LaDepartmentWatcher::Config.get.config[:departments].each do |name, options|
        Rails.logger.info("Check department #{name}")
        find_for_status = options['online_statuses'].downcase.split(",")
        department = Department.find_by_departmentid(options['departmentid'])
        # watch for offline status
        notify(department, find_for_status)

        # watch for sum of offline per day
        notify_per_day(department)
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
    # @param [LaDepartmentWatcher::Department] department
    # @param [Array<String>] online_statuses
    # @return [Symbol]
    def self.notify(department, online_statuses)
      result = nil
      online_statuses = online_statuses.map { |i| i.downcase }
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


    # @param [LaDepartmentWatcher::Department] department
    # @return [Symbol]
    def self.notify_per_day(department)
      res = nil
      d = Time.zone.now - 1.day
      return :already_reported if DailyOfflineAlert.reported_at?(d)

      daily_alert = DailyOfflineAlert.new(notify_sent_at: d)
      daily_alert.department = department
      if daily_alert.email_alert?
        DepartmentMailer.notify_daily_alert(daily_alert, department)
        daily_alert.save
        res = :notify
      end      
      res
    end

  end
end