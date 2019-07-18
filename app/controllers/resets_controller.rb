class ResetsController < ActionController::Base
	skip_before_action :verify_authenticity_token
	def create
		if params[:email] 
			@user = User.where(:email => params[:email]).first
			if @user && @user.confirmed
				@user.make_reset_token
				RegistrationMailer.forgot_password(@user).deliver_later
				render :json => {msg: "please check your email"}
			else
				render :json => {msg: "no user with that email"}, status: 404
			end
		else
			render :json => {msg: "error in the request: email is not in params"} ,status: 400
		end
	end

	def edit
		@user = User.where(:reset_token => params[:reset_token], :email => params[:email]).first
		if !@user
			render :json => {msg: "error in the request"} , status: 401
			return
		end
	end

	def password_reset
		@user = User.where(:reset_token => params[:user][:reset_token], :email => params[:user][:email]).first
		if @user
			if @user.update_password params[:user][:password]
				render :json => {msg: "password is updated"}
			else
				render :json => {msg: "password is not passing the validations"} ,status: 400
			end
		else
			render :json => {msg: "token is modified"} , status: 401
		end
	end
end