module LaDepartmentWatcher
  class Event < ActiveRecord::Base
    attr_accessible :agents_statuses_json, :end_at, :notify_sent_at, :notify_sent_to, :start_at, :text_description, :type, :department_id

    def self.start_alert(department)
      alert = Alert.create(department_id: department.id, start_at: DateTime.now(), text_description: "Department #{department.name} is  offline")
    end

    def self.end_alert(department)
      alert = Alert.last(department.id)
      alert.update_attributes( end_at: DateTime.now())
      DepartmentMailer.notify_alert_end(department)
    end

    def notify_sent?
      !notify_sent_at.nil?
    end

  end

end
