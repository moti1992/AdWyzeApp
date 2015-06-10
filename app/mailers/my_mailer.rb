class MyMailer < Devise::Mailer
  include Resque::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default from: "moti@mailinator.com"

  def confirmation_instructions(record, token, opts={})
    Resque.logger.warn "Registration confirmation email initiated..."
    @user = User.new(record)
    @token = token
    mail(:to => @user.email, :subject => "Confirm Your Account")
  end

  def reset_password_instructions(record, token, opts={})
    Resque.logger.warn "Reset password email initiated..."
    @user = User.new(record)
    @token = token
    mail(:to => @user.email, :subject => "Password Reset Request")
  end
end