require 'active_resource'

class SocialcastAPI < ActiveResource::Base
  auth = YAML::load(File.open('socialcast.yml'))
  self.site = "https://#{auth['subdomain']}.socialcast.com/api/"
  self.user = auth['user']
  self.password = auth['password']
end

class Message < SocialcastAPI

  class Like < SocialcastAPI
    self.site = Message.site.to_s + "messages/:message_id/"
  end

  class Flag < SocialcastAPI
    self.site = Message.site.to_s + "messages/:message_id/"
  end

  def self.search(args = {})
    get(:search, args).map {|message| Message.new(message)}
  end
  
  def like
    Message.post(id.to_s + '/likes')
  end
  
  def unlike
    likedbyme = likes.select {|alike| alike.unlikable}.first
    if likedbyme
      likedbyme.prefix_options = {:message_id => self.id}
      likedbyme.destroy 
    end
  end
  
  def flag
    Message.post(id.to_s + '/flags')
  end

  def unflag
    Message.delete(id.to_s + '/flags/' + attributes[:flag].id)
  end

end

class Comment < SocialcastAPI

  self.site = Message.site.to_s + "messages/:message_id/"

  class Like < SocialcastAPI
    self.site = Comment.site.to_s + "comments/:comment_id/"
  end

  def like
    Comment.post(id.to_s + '/likes')
  end
  
  def unlike
    likedbyme = likes.select {|alike| alike.unlikable}.first
    if likedbyme
      likedbyme.prefix_options = {:message_id => message_id, :comment_id => self.id}
      likedbyme.destroy 
    end
  end

end

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
    User.post(id.to_s + '/followers')
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
