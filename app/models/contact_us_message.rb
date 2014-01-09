# == Schema Information
#
# Table name: contact_us_messages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactUsMessage < ActiveRecord::Base
  attr_accessible :content, :email, :name, :as => [:default, :admin]

  after_save :email_after_save

  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create}

  def email_after_save
	  begin
      ContactUsMailer.contact_us_mail(self).deliver
    rescue Exception =>e
      logger.fatal e.message
    end
  end
end
