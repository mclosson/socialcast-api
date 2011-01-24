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

  def self.search_all_pages(args = {})
    results = Array.new
    page = 1
    per_page = 500    
    
    begin
      messages = get(:search, :page => page, :per_page => per_page, :q => args[:q]).map {|message| Message.new(message)}
      page += 1
      results += messages
    end until messages.count < per_page

    return results
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
  
  def unfollow
    delete('followers/' + contact_id.to_s)  
  end
  
  def following(args = {})
    get(:following, args).map {|user| User.new(user)}
  end

  def self.all_pages
    results = Array.new
    page = 1
    per_page = 500    
    
    begin
      users = all(:params => {:page => page, :per_page => per_page})
      page += 1
      results += users
    end until users.count < per_page

    return results
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

# This class is not working or tested yet, just a frame!
class Attachment < SocialcastAPI
end
