class MessagesController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    @message = current_user.messages.build( message_params )
    if @message.save
      flash[ :success ] = "Message sent!"
    else
      flash[ :danger ] = "Message couldn't be sent!"
    end
    redirect_to messages_user_path( current_user )
  end

  private
    def message_params
      params.require( :message ).permit( :receiver_id, :content )
    end
end
