class ImageSerializer < ApplicationSerializer
  attributes :image_url , :token

  def image_url
  if !object.avatar.attached?
		image_url = "no avatar"
	else
		image_url = url_for(object.avatar)
	end
  end

  def token
  	token = @instance_options[:token]
  end
end
