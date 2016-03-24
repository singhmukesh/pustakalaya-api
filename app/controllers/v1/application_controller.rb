class V1::ApplicationController < ActionController::Base
  include Pundit
  include Authentication
  before_action :authenticate_user!

  rescue_from CustomException::Unauthorized, with: :unauthorized
  rescue_from CustomException::RequestTimeOut, with: :request_timeout
  rescue_from CustomException::DomainConflict, with: :domain_conflict
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::StatementInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Authenticate user from the auth token provided in the header of request and
  #   Instance variable @current_user to access the Authenticate user
  #
  # @required Authorization [String], Request header containing Gmail Oauth auth token
  #
  # @return [User::ActiveRecord_Relation], Active Record Object containing the user details
  def authenticate_user!
    # token = request.headers['Authorization']
    # auth = Authentication::get_user_info_from_access_token(token)
    #
    # Authentication::authenticate_domain(auth) if ENV['AUTH_DOMAIN']
    #
    # @current_user = User.find_user(auth)
    @current_user = User.first
  end

  # Provide Authenticated current user details
  #
  # @return [User::ActiveRecord_Relation], Active Record Object containing the user details
  def current_user
    @current_user
  end

  private

  def paginate(collections)
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || WillPaginate.per_page).to_i
    collections.paginate(page: page, per_page: per_page).order(created_at: :desc)
  end

  def unauthorized(error)
    render json: {message: error.message}, status: :unauthorized
  end

  def request_timeout(error)
    render json: {message: error.message}, status: :request_timeout
  end

  def domain_conflict(error)
    render json: {message: error.message}, status: :conflict
  end

  def user_not_authorized
    render json: {message: I18n.t('exception.not_permitted')}, status: :unauthorized
  end

  def record_invalid(error)
    render json: {message: error.message}, status: :unprocessable_entity
  end

  def record_not_found(error)
    render json: {message: error.message}, status: :not_found
  end
end
