class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[show update set_best destroy]
  before_action :set_question, only: %i[new create]

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
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      render 'shared/_no_roots'
    end
  end

  def set_best
    if current_user.author?(@answer.question)
      @answer.set_best_mark
    else
      render 'shared/_no_roots'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    else
      render 'shared/_no_roots'
    end
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
