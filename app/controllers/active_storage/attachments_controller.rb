class ActiveStorage::AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment, only: %i[destroy]

  def destroy
    if current_user.author?(@attachment.record)
      @attachment.purge
    else
      render 'shared/_no_roots'
    end
  end

  private
  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
