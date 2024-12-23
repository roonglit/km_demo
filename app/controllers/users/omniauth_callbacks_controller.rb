module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def github
      # p request.env["omniauth.auth"]
      # @user = User.from_omniauth(request.env["omniauth.auth"])

      # if @user.persisted?
      #   sign_in_and_redirect @user, event: :authentication
      #   set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      # else
      #   session["devise.facebook_data"] = request.env["omniauth.auth"]
      #   redirect_to new_user_registration_url
      # end
    end

    def keycloakopenid
      # p request.env["omniauth.auth"]

      @user = User.from_keycloak_openid(request.env["omniauth.auth"])
      @user.update(
        token: request.env["omniauth.auth"]["credentials"]["token"],
        refresh_token: request.env["omniauth.auth"]["credentials"]["refresh_token"],
        token_expires_at: Time.at(request.env["omniauth.auth"]["credentials"]["expires_at"])
      )
      sign_in_and_redirect @user, event: :authentication
    end

    def failure
      redirect_to root_path
    end

    def find_for_oauth(provider, auth)
      p auth[:info][:email]

      # if account is not found, create a new account
    end
  end
end