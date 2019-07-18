class AuthorizeApiRequest
	def initialize	(headers= {})
		@headers = headers
	end
	def call
		if http_auth_header && decode_auth_token
			@user = User.where(:email =>  @body["email"]).first
			@device = Device.where(:user_id => @user.id , :uuid => @body["device"]).first
			if !(@device  && @device.logged_in)
				return nil
			end
			return {user: @user, device: @device}
		else
			return nil
		end
	end


	private

	def decode_auth_token
		@body = JasonWebToken.decode @headers["HTTP_AUTHORIZATION"]
	end

	def http_auth_header
		if @headers["HTTP_AUTHORIZATION"]
			return true
		else
			return false
		end
	end
end