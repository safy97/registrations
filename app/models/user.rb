class User < ApplicationRecord
	include ActiveStorageSupport::SupportForBase64
  has_many :devices , :dependent => :delete_all
  has_one_base64_attached :avatar
	has_secure_password
	before_create :confirmation_token
	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
	validates :username ,  :presence => true,
						   :length => {:in => 4..30},
						   :uniqueness => true
  	
  	validates :email, :presence => true,
    	              :length => { :maximum =>  50 },
                      :format => EMAIL_REGEX ,
                      :uniqueness => true

    validates :password, :length => {:in => 3..40} ,:on => :create

    def confirm_user
    	if !self.confirmed
	    	self.confirmed= true
	    	save!(:validate => false)
	    	return true
	    else
	    	return false
	    end
    end

    def make_reset_token
    	self.reset_token = SecureRandom.urlsafe_base64.to_s
    	if save!
    		puts "saved ........>>>>>>>>>>>>>>"
    	else
    		puts "not saved.....>>>>>>>>>>>>>"
    	end
    	return self.reset_token
    end

    def update_password new_password
    	self.reset_token = nil
    	self.password = new_password
    	if save!
    		puts "password changed.......>>>>>>>>"
    		true
    	else
    		puts "password not changed.....>>>>>>"
    		false
    	end
    end
    private
	def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
