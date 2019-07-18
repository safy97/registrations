class UsersController < ApiController
	
	skip_before_action :authorized_user , only: [:verify , :create]
	def create
		@user = User.new(get_params)
		if params[:avatar]
			begin
				@user.avatar = {data: params[:avatar]}
			rescue
				render :json => {msg: "avatar not in right format "} , status: 500
				return
			end	
		end
		if @user.save
			RegistrationMailer.registration_confirmation(@user).deliver_later
			render :json => {msg: "check your email"}
		else
			render :json => {error: @user.errors.full_messages} , status: 400
		end	

	end


	def show
		@target_user = User.find_by_id(params[:id])
		if @target_user
			render :json => @target_user  
		else
			render :json => {msg: "user not found"} , status: 404
		end
	end


	def verify
		@user = User.where(:confirm_token => params[:confirm_token], :email => params[:email]).first
		if @user
			if  @user.confirm_user
				render :json => {success: "verified"}
			else
				render :json => {success: "already verified"} , status: 400
			end
		else
			render :json => {fail: "error in the request"} ,status: 401
		end
	end


	private


	def get_params
		params.permit(:email , :username , :password)
	end
end