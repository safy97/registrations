class ApiController < ActionController::API
	
	before_action :authorized_user


	private

	 def authorized_user
	 	@body = AuthorizeApiRequest.new(request.env).call
	 	if ! @body
	 		render :json => {error: "user is not authorized (new error) "} ,status: 401
	 		return false
	 	else
	 		@user = @body[:user]
	 		@device = @body[:device]
	 	end
	 end
end
