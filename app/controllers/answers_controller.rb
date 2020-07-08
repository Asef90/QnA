class AnswersController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_answer, only: %i[show update destroy set_best]
  before_action :set_question, only: %i[new create]

  include Voted

  authorize_resource

  def show

  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def set_best
    question = @answer.question
    @answer.set_best_mark
  end

  def destroy
    @answer.destroy
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end

end
