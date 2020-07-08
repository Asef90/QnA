class QuestionsController < ApplicationController
  # before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]
  
  include Voted

  authorize_resource

  def index
    @questions = Question.order(:id)
  end

  def show
    @answer = Answer.new
    @answer.links.build
    # @comment = Comment.new
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      current_user.subscripted_questions.push(@question)
      ActionCable.server.broadcast 'questions', @question
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    @answer = Answer.new
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end
end
