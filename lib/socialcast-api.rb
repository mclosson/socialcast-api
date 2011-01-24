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
      Base.update_connection
    end
    Configuration.instance
  end
  
  class Base < ActiveResource::Base
    def self.update_connection
      self.site = "https://#{SocialcastApi.configuration.domain}/api/"
      self.user = SocialcastApi.configuration.user
      self.password = SocialcastApi.configuration.password
    end
  end
  
  class Message < Base

    class Like < Base
      self.site = Message.site.to_s + "messages/:message_id/"
    end

    class Flag < Base
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

  class Comment < Base

    self.site = Message.site.to_s + "messages/:message_id/"

    class Like < Base
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

  class User < Base

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

  class Stream < Base
  
    def messages(args = {})
      get(:messages, args).map {|message| Message.new(message)}
    end

  end

  class Group < Base
  
    def members(args = {})
      get(:members, args).map {|member| User.new(member)}
    end
  
  end

  class GroupMembership < Base
  end

  class Category < Base
  end

  class ContentFilter < Base
  end

  # This class is not working or tested yet, just a frame!
  class Attachment < Base
  end
end