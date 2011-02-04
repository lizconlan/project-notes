require 'authlogic'

class User < ActiveRecord::Base  
  acts_as_authentic
  
  has_many :permissions
  has_many :projects, :through => :permissions
  
  class << self
    # to create initial admin user
    def create_admin_user(password)
      if count > 0
        raise 'admin user already exists'
      elsif password.blank?
        raise 'password cannot be blank'
      else
        User.create!(:login=>'admin', :admin=>true, :password=>password, :password_confirmation=>password)
      end
    end
  end
end