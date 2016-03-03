class V1::ItemsController < V1::ApplicationController
  before_action :set_item, only: [:show, :change_status]

  def create
    authorize Item
    @item = Item.new(item_params)
    @item.save!
  end

  def show
  end

  # @url v1/items/status
  # @action GET
  #
  # Toggle status of the item
  #
  # @required id [Integer] Id of item whose status is to be change
  # @required status [Integer] 0 to Activate and 1 to Deactivate
  #
  # @response [Json]
  def change_status
    authorize Item
    @item.update({status: Item.statuses[status]})
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :code, :quantity, :description, :image, :status, :type, category_ids: [], publish_detail_attributes: [:id, :item_id, :isbn, :author, :publish_date])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def status
    params[:status].upcase.to_sym
  end
end
