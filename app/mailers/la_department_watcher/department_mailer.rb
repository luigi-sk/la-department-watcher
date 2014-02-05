module LaDepartmentWatcher
  class DepartmentMailer < ActionMailer::Base
    default from: LaDepartmentWatcher::Config.get.config[:notify_from]

    def notify_alert(department)
      @department = department
      @minutes_offline = (LaDepartmentWatcher::Config.get.config[:notify_offset] * (1 / 60)).to_i
      mail( to: LaDepartmentWatcher::Config.get.config[:notify_to],
           subject: "Department #{department.name} is offline")
    end
  end
end
