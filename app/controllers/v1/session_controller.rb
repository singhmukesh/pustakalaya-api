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
end
