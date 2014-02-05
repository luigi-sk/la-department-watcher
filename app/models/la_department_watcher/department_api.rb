module LaDepartmentWatcher
  class DepartmentApi
    URL_PREFIX = '/departments'

    def self.find(department_id)
      LaApi.get("#{URL_PREFIX}/#{department_id}")
    end

    def self.list
      LaApi.get("#{URL_PREFIX}")
    end

    def self.agents
      LaApi.get("#{URL_PREFIX}/agents")
    end

  end
end
