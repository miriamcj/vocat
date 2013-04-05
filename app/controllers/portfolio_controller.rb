class PortfolioController < ApplicationController

  def index
    if current_user.role? :evaluator
			@submissions = Submission.for_course(current_user.evaluator_courses).includes(:project, :course).limit(10)

    else
			# See https://github.com/evrone/active_model_serializers/commit/22b6a74131682f086bd8095aaaf22d0cd6e8616d
			@submissions = Submission.for_creator(current_user).includes(:project, :course).limit(10)
    end
  end

end