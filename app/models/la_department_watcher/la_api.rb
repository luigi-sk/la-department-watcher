require 'httparty'

module LaDepartmentWatcher
  class LaApi
    include HTTParty
    base_uri LaDepartmentWatcher::Config.get.config[:api_url]

    def self.get(url, options = {})
      url = add_api_key(url)
      super(url, options)['response']
    end

    private

    def self.add_api_key(url)
      "#{url}?apikey=#{LaDepartmentWatcher::Config.get.config[:api_key]}"
    end
  end
end