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
  end
end
