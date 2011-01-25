require 'active_resource'
require 'singleton'

module SocialcastApi
  class Configuration
    include Singleton
    ATTRIBUTES = [:domain, :user, :password]
    attr_accessor *ATTRIBUTES
  end
  
  def self.configuration
    if block_given?
      yield Configuration.instance
      require 'socialcast-api/base'
    end
    Configuration.instance
  end

end