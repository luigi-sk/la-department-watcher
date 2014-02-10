module LaDepartmentWatcher
  class DailyOfflineAlert < Event
    def email_alert?
      allowed_offline = Config.get.config[:max_daily_offline].to_i
      offline = DailyOfflineAlert.sum_offline_time(alerts, notify_sent_at)
      Rails.logger.info("email_alert? #{offline} > #{allowed_offline}")
      offline > allowed_offline
    end

    def alerts
      department.find_alerts_by_date(self.notify_sent_at)
    end

    def self.reported_at?(date)
      date = date.to_time
      DailyOfflineAlert.where("notify_sent_at BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).first
    end

    def self.sum_offline_time(alerts, date)
      res = 0
      alerts.each do |alert|
        start_at = [alert.start_at, date.to_time.beginning_of_day].max()
        end_at = [alert.end_at, date.to_time.end_of_day].min()

        res += Alert.new(start_at: start_at, end_at: end_at).duration
      end
      res
    end
  end
end