ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings={
	address:"mail.anytickets.com",
	port: 465,
	domain:"Anytickets.com",
	user_name:"admin@anytickets.com",
	password:"Anytickets1",
	authentication:"plain",
	enable_starttls_auto:true
}
