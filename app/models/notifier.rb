class Notifier < ActionMailer::Base

default_url_options[:host] = "www.resource-tracking.com"

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Resource tracking  "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.persistence_token)
  end

end

