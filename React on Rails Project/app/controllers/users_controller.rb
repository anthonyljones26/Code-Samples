class UsersController < ApplicationController
  protect_from_forgery with: :null_session, if: proc { |c| c.request.format.json? }

  def update
    user_id = user_id_param

    if user_id >= 0 && @all_users[user_id]
      session[:active_user_index] = user_id
      render_ok message: 'update successful'
    else
      render_internal_server_error message: 'update failed'
    end
  end

  private

  def user_id_param
    params.fetch(:id, -1).to_i
  end
end
