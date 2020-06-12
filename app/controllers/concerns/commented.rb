module Commented
  extend ActiveSupport::Concern
  included do
    before_action :set_commentable, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.build(comment_params)
    @comment.author = current_user
    if @comment.save
      publish_comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def publish_comment
    question = @commentable.is_a?(Question) ? @commentable : @commentable.question
    CommentsChannel.broadcast_to question, comment: @comment
  end
end
