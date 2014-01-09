class ContactUsMessagesController < ApplicationController
 
  # POST /contact_us_messages
  def create
    @contact_us_message = ContactUsMessage.new(params[:contact_us_message])

    respond_to do |format|
      if @contact_us_message.save
        format.html { redirect_to root_path, notice: t(:contact_us_success) }
      else
        format.html { redirect_to root_path, notice: t(:contact_us_failure) }
      end
    end
  end

 
end
