module LaDepartmentWatcher
  class Config
    @@instance = nil
    cattr_accessor :instance
    attr_accessor :config

    def self.get
      @@instance = @@instance || self.new
    end

    private
    def initialize
      file_path = "#{Rails.root}/config/la.yml"
      Rails.logger.info("Initializing LaDepartmentWatcher::Config from #{file_path}")
      @config = YAML.load_file(file_path).to_hash.with_indifferent_access
    end

  end
end