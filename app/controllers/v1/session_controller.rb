class V1::SessionController < V1::ApplicationController
  skip_before_action :authenticate_user!

  # @url v1/session/login
  # @action POST
  #
  # Login user with Google OAuth authorization_code
  #
  # @required code [String] Authorization code
  #
  # @response [Json] containing refresh token and access token
  def login
    @login = Authentication::login(params[:authorization_code])
  end

  # @url v1/session/refresh
  # @action POST
  #
  # Provides new access_token on behalf of refresh_token
  #
  # @required code [String] Refresh code
  #
  # @response [Json] containing access token
  def refresh
    @access_token = Authentication::refresh(params[:refresh_token])
  end
end
