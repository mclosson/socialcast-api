require 'active_resource'
require 'singleton'
require 'yaml'

module SocialcastApi
  class Configuration
    include Singleton
    ATTRIBUTES = [:site, :user, :password, :config_file]
    attr_accessor *ATTRIBUTES
  end

  def self.configuration
    if block_given?
      yield Configuration.instance
      if Configuration.instance.config_file
        config = YAML::load_file(Configuration.config_file)
        Configuration.site = config['site']
        Configuration.user = config['user']
        Configuration.password = config['password']
      end
      require 'socialcast-api/base'
    end
    Configuration.instance
  end

end
