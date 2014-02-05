module LaDepartmentWatcher
  class Alert < Event
    def self.last(department_id)
      Alert.where(department_id: department_id).order('created_at DESC').limit(1).first
    end

    def email_alert?
      (end_at.to_i - start_at.to_i) > LaDepartmentWatcher::Config.get.config[:notify_offset]
    end
  end
end