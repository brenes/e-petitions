class FeedbackController < ApplicationController
  ssl_required :index, :create, :thanks

  respond_to :html
  def index
    respond_with @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.valid?
      FeedbackMailer.send_feedback(@feedback).deliver
      redirect_to thanks_feedback_path
    else
      render 'index'
    end
  end

  def thanks
  end
end
