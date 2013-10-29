module Rapidfire
  class AnswerGroupsController < Rapidfire::ApplicationController
    before_filter :find_question_group!
    before_filter :is_signed_in?, except:[:new]

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)

      if @answer_group_builder.save
        UserMailer.new_survey_answers(@question_group, current_user).deliver
        action = Action.where(action:"Answered Survey", user_id:current_user.id, to_user_id:@question_group.user_id)
        if action == []
          Action.new(user_id:current_user.id, to_user_id:@question_group.user_id, action:"Answered Survey").save
        end
        user = User.find(@question_group.user_id)
        redirect_to main_app.user_path(user.user_name)
      else
        render :new
      end
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def answer_group_params
      answer_params = { params: params[:answer_group] }
      answer_params.merge(user: current_user, question_group: @question_group)
    end
  end
end
