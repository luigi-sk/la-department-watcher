module LaDepartmentWatcher
  class DepartmentMailer < ActionMailer::Base
    default from: LaDepartmentWatcher::Config.get.config[:notify_from]

    def notify_alert(department)
      @department = department
      @minutes_offline = (LaDepartmentWatcher::Config.get.config[:notify_offset] * (1.0 / 60)).to_i

      alert = department.last_alert

      unless alert.notify_sent?
        alert.update_attributes(notify_sent_at: DateTime.now())
        mail( to: LaDepartmentWatcher::Config.get.config[:notify_to],
              subject: "Department #{department.name} is offline").deliver
      end
    end

    def notify_alert_end(department)
      @department = department
      @alert = department.last_alert
      @minutes_offline = (@alert.duration * (1.0 / 60)).to_i

      mail( to: LaDepartmentWatcher::Config.get.config[:notify_to],
            subject: "Department #{department.name} is online").deliver
    end

    def notify_daily_alert(daily_alert, department)
      @department = department
      @daily_alert = daily_alert
      @alerts = daily_alert.alerts
      @limit = (Config.get.config[:max_daily_offline].to_i * (1.0 / 60)).to_i
      @minutes_offline = (DailyOfflineAlert.sum_offline_time(@alerts, @daily_alert.notify_sent_at) * (1.0 / 60)).to_i
      mail( to: LaDepartmentWatcher::Config.get.config[:notify_to],
            subject: "Department #{department.name} exceed daily offline limit").deliver
    end
  end
end
