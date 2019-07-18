class SessionsController < ApiController
	skip_before_action :authorized_user , only: [:create]
	def create
		if params[:email] && params[:password] && params[:device]
			@user = User.where(:email => params[:email]).first
			if @user && @user.authenticate(params[:password])
				if @user.confirmed
						@device = Device.where(user_id: @user.id, uuid: params[:device]).first
						if !@device   				#first time login from this device create session
							@device = Device.create(user_id: @user.id , uuid: params[:device])
						else
							@device.update(:logged_in => true)
						end
						#@user.update(:logged_in => true)
						token = JasonWebToken.encode ({:email => @user.email , :device => params[:device]})
						render :json => {token: token}
				else
					render :json => {error: "account not verified"}, status: 401
				end
			else
				render :json => {token: "email and password doen't match"} , status: 401
			end
		else
			render :json => {token: "error happen while request"}, status: 400
		end	
	end



	def destroy
		#body = JasonWebToken.decode request.env["HTTP_AUTHORIZATION"]
		#if body 
			#@user = User.where(:email => body["email"]).first
			
		#else
		#	render :json => {fail: "token is modified"} ,status: 401
		#end	

		@device.update(logged_in: false)
		render :json => {msg: "you logged out"}
	end
end