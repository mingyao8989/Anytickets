class ContactUsMailer < ActionMailer::Base
  default from: "mailer@anytickets.com"

  def contact_us_mail(message)
  	@message = message
  	mail to: "tsah.weiss@gmail.com",subject: "message from:#{message.name}"
    # mail to: "info@anytickets.com",subject: "message from:#{message.name}"
  end
end
