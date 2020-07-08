class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]

  authorize_resource

  def create
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

  def param
    "#{params[:commentable].singularize}_id".to_sym
  end

  def model_klass
    params[:commentable].classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[param])
  end

  def publish_comment
    question = @commentable.is_a?(Question) ? @commentable : @commentable.question
    CommentsChannel.broadcast_to question, comment: @comment
  end
end
