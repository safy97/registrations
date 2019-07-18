class RegistrationMailer < ApplicationMailer


  def registration_confirmation(user)
  	@user = user
    mail(:to => "#{@user.email}", :subject => "Registration Confirmation")
  end

  def forgot_password(user)
  	@user = user
    mail(:to => "#{@user.email}", :subject => "Forgot your password")
  end
end
