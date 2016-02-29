class V1::ApplicationController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def paginate(collections)
    collections.result.paginate(page: params[:page], per_page: params[:per_page]).order('created_at DESC')
  end

  def record_invalid(error)
    render json: {message: error.message}, status: :unprocessable_entity
  end
end
