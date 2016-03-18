class V1::RatingsController < V1::ApplicationController

  def create
    @rating = current_user.ratings.find_by(item_id: params[:item_id])
    unless @rating
      @rating = current_user.ratings.new(rating_params)
      @rating.save!
    else
      @rating.update!(rating_params)
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:id, :value, :item_id)
  end
end
