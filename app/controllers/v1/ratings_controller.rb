class V1::RatingsController < V1::ApplicationController

  def create
    @rating = current_user.ratings.new(rating_params)
    @rating.save!
  end

  private

  def rating_params
    params.require(:rating).permit(:id, :value, :item_id)
  end
end
