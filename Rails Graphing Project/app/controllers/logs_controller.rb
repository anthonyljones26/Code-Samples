class LogsController < ApplicationController
  def create
    log_user_event(params[:EventDomain], params[:EventType], params[:Description])
    render plain: '', status: 201
  end
end
