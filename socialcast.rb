require 'active_resource'

class SocialcastAPI < ActiveResource::Base
  auth = YAML::load(File.open('socialcast.yml'))
  self.site = "https://#{auth['subdomain']}.socialcast.com/api/"
  self.user = auth['user']
  self.password = auth['password']
end

class Message < SocialcastAPI
  
  def self.search(args = {})
    get(:search, args).map {|message| Message.new(message)}
  end
  
  def like
    post(:likes)
  end
 
end

class User < SocialcastAPI

  def self.search(args = {})
    get(:search, args).map {|user| User.new(user)}
  end
  
  def messages
    get(:messages).map {|message| Message.new(message)}
  end
  
end

class Group < SocialcastAPI
  
  def members(args = {})
    get(:members, args).map {|member| User.new(member)}
  end
  
end

class GroupMembership < SocialcastAPI
end
