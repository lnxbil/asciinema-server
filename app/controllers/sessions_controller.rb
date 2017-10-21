class SessionsController < ApplicationController

  def destroy
    self.current_user = nil
    redirect_to root_path, notice: "See you later!"
  end

  def new
    if GITLAB_ENABLED
      redirect_to '/auth/gitlab'
    end
  end

  def create
    if GITLAB_ENABLED
      auth = request.env["omniauth.auth"]
      user = User.where(:username => auth['info']['username'].to_s).first || User.create_with_omniauth(auth)
      # Reset the session after successful login, per
      # 2.8 Session Fixation – Countermeasures:
      # http://guides.rubyonrails.org/security.html#session-fixation-countermeasures
      reset_session
      warden.set_user(user, scope: :user)
      if user.email.blank?
        redirect_to edit_user_path(user), :alert => "Please enter your email address."
      else
        redirect_to root_url, :notice => 'Signed in from GitLab'
      end
    end
  end
end
