module LaDepartmentWatcher
  class Alert < Event
    def self.last(department_id)
      Alert.where(department_id: department_id).order('created_at DESC').limit(1).first
    end

    def email_alert?
      end_at = DateTime.now() || end_at
      return false if start_at.nil?
      (end_at.to_i - start_at.to_i) > LaDepartmentWatcher::Config.get.config[:notify_offset]
    end

    def closed?
      !end_at.nil?
    end

    def duration
      [(end_at.to_i - start_at.to_i), 0].max()
    end
  end
end