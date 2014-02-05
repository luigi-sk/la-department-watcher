module LaDepartmentWatcher
  class Department < ActiveRecord::Base
    attr_accessible :departmentid, :name, :onlinestatus, :presetstatus
    has_many :alerts

    def self.find_by_department(department)
      department_db = Department.where(departmentid: department['departmentid']).order("created_at DESC").limit(1).first
      department_db = Department.new() if department_db.nil?
      department_db.update_from_api(department)
      department_db
    end

    def ok?()
      alert = alerts.order("created_at DESC").limit(1).first
      # its ok if last alert doesnt exist OR last alert is ended
      alert.nil? || !alert.end_at.nil?
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
