class V1::ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from CustomException::Unauthorized, with: :unauthorized
  rescue_from CustomException::RequestTimeOut, with: :request_timeout

  # Authenticate user from the auth token provided in the header of request and
  #   Instance variable @current_user to access the Authenticate user
  #
  # @required Authorization [String], Request header containing Gmail Oauth auth token
  #
  # @return [User::ActiveRecord_Relation], Active Record Object containing the user details
  def authenticate_user!
    token = request.headers['Authorization']
    auth = Authentication::authenticate_with_oauth(token)

    Authentication::authenticate_domain(auth) if ENV['AUTH_DOMAIN']
    @current_user = Authentication::find_user(auth)
  end

  # Provide Authenticated current user details
  #
  # @return [User::ActiveRecord_Relation], Active Record Object containing the user details
  def current_user
    @current_user
  end

  private

  def unauthorized(error)
    render json: {message: error.message}, status: :unauthorized
  end

  def request_time_out(error)
    render json: {message: error.message}, status: :request_timeout
  end
end
