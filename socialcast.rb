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
  
  # Unlike a message
  # def unlike
  # end
  
  def flag
    post(:flags)
  end

  # Unflag a message
  # def unflag
  # end

end

class User < SocialcastAPI

  def self.search(args = {})
    get(:search, args).map {|user| User.new(user)}
  end
  
  def messages
    get(:messages).map {|message| Message.new(message)}
  end
  
  def followers(args = {})
    get(:followers, args).map {|follower| User.new(follower)}
  end
  
  def follow
    post(:followers)
  end
  
  # Unfollow a user
  # def unfollow
  # end
  
  def following(args = {})
    get(:following, args).map {|user| User.new(user)}
  end
  
end

class Stream < SocialcastAPI
  
  def messages(args = {})
    get(:messages, args).map {|message| Message.new(message)}
  end

end

class Group < SocialcastAPI
  
  def members(args = {})
    get(:members, args).map {|member| User.new(member)}
  end
  
end

class GroupMembership < SocialcastAPI
end

class Category < SocialcastAPI
end

class ContentFilter < SocialcastAPI
end

class Attachment < SocialcastAPI
end