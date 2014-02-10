module LaDepartmentWatcher
  class Department < ActiveRecord::Base
    attr_accessible :departmentid, :name, :onlinestatus, :presetstatus
    has_many :alerts, :class_name => 'LaDepartmentWatcher::Alert'
    has_many :daily_offline_alerts, :class_name => 'LaDepartmentWatcher::Alert'

    def self.find_by_department(department)
      department_db = self.find_by_departmentid(department['departmentid'])
      department_db = Department.new() if department_db.nil?
      department_db.update_from_api(department)
      department_db
    end

    def self.find_by_departmentid(departmentid)
      Department.where('departmentid' => departmentid).order("created_at DESC").limit(1).first
    end

    def last_alert
      alerts.order("created_at DESC").limit(1).first
    end

    def find_alerts_by_date(date)
      alerts.where("(start_at BETWEEN :from AND :to) AND (end_at BETWEEN :from AND :to)",
        { from: date.to_time.beginning_of_day, to: date.to_time.end_of_day })
    end

    def ok?()
      alert = last_alert
      # its ok if last alert doesnt exist OR last alert is ended
      alert.nil? || alert.closed?
    end

    def update_from_api(department)
      self.departmentid = department['departmentid']
      self.name = department['name']
      self.onlinestatus = department['onlinestatus']
      self.presetstatus = department['presetstatus']
      self.save
    end
  end
end
