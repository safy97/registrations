class RegistrationsController < ActionController::Base
	skip_before_action :verify_authenticity_token
	def signup
		@user = User.create(get_params)
		@user.avatar = {data: params[:avatar]}
		if @user.save
			token = JasonWebToken.encode ({:email => @user.email})
			RegistrationMailer.registration_confirmation(@user).deliver_later
			render :json => {token: token}
		else
			render :json => {error: @user.errors.full_messages}
		end
	end


	def login
		if params[:email] && params[:password]
			@user = User.where(:email => params[:email]).first
			if @user && @user.authenticate(params[:password])
				if @user.confirmed
					if !@user.logged_in
						@user.update(:logged_in => true)
						token = JasonWebToken.encode ({:email => @user.email})
						render :json => {token: token}
					else
						render :json => {error: "account is already logged in"}
					end
				else
					render :json => {error: "account not verified"}
				end
			else
				render :json => {token: "email and password doen't match"}
			end
		else
			render :json => {token: "error happen while request"}
		end

	end


	def confirm
		@user = User.where(:confirm_token => params[:confirm_token]).first
		if @user
			if @user.confirm_user
				render :json => {success: "verified"}
			else
				render :json => {success: "already verified"}
			end
		else
			render :json => {fail: "error in the request"}
		end
	end













	def forgot
		if params[:email] 
			@user = User.where(:email => params[:email]).first
			if @user
				@user.make_reset_token
				RegistrationMailer.forgot_password(@user).deliver_later
				render :json => {msg: "please check your email"}
			else
				render :json => {msg: "no user with that email"}
			end
		else
			render :json => {msg: "error in the request: email is not in params"}
		end
	end


	def reset
		@user = User.where(:reset_token => params[:reset_token], :email => params[:email]).first
		if !@user
			render :json => {msg: "error in the request"}
			return
		end
	end
	def password_change
		@user = User.where(:reset_token => params[:user][:reset_token], :email => params[:user][:email]).first
		if @user
			if @user.update_password params[:user][:password]
				render :json => {msg: "password is updated"}
			else
				render :json => {msg: "password is not passing the validations"}
			end
		else
			render :json => {msg: "token is modified"}
		end


	end














	def logout
		body = JasonWebToken.decode params[:token]
		if body 
			@user = User.where(:email => body["email"]).first
			if @user
				@user.update(:logged_in => false)
				render :json => {logout: "you logged out"}
			else
				render :json => {error: "no user with that email"}
			end
		else
			render :json => {fail: "token is modified"}
		end

	end



	def check
		
			if params[:token]
				body = JasonWebToken.decode params[:token]
				if body
	     			@user = User.where(:email =>  body["email"]).first
	     			if  @user && @user.logged_in
		     			if !@user.avatar.attached?
		     				body[:url_image] = "no avatar"
		     			else
		     				body[:url_image] = url_for(@user.avatar)
		     			end
		   				render :json => body
		   			else
		   				render :json => {error: "please log in again"}
		   			end
				else
					render :json => {error: "token has been changed"}
				end
			else
				render :json => {error: "token is not send"}
			end

	end


	private 
	def get_params
		params.permit(:username, :password,:email)
	end
	
end