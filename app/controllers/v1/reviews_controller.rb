class V1::ReviewsController < V1::ApplicationController

  def create
    @review = current_user.reviews.new(review_params)
    @review.save!
  end

  private

  def review_params
    params.require(:review).permit(:id, :description, :item_id)
  end
end
