class UserSerializer < ApplicationSerializer
  attributes :id , :avatar , :username, :email  

  def avatar
	if !object.avatar.attached?
		 return "no avatar"
	else
		return url_for(object.avatar)
	end
  end

end
