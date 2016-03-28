class V1::RatingsController < V1::ApplicationController

  def create
    @rating = Rating.where(user_id: current_user.id, item_id: params[:rating][:item_id]).first
    unless @rating
      @rating = current_user.ratings.new(rating_params)
      @rating.save!
    else
      @rating.update!(rating_params)
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:id, :value, :item_id, :review)
  end
end
