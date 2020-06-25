class AttachmentsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_attachment, only: %i[destroy]

  authorize_resource

  def destroy
    @attachment.purge
  end

  private
  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
