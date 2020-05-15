class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show destroy]
  before_action :set_question, only: %i[new create]

  def show

  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      @question.answers.delete(@answer)
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    else
      redirect_to @answer.question, notice: 'Not enough access rights.'
    end

  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
