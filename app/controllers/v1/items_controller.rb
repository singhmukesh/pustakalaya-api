class V1::ItemsController < V1::ApplicationController

  def create
    @item = Item.new(item_params)
    @item.save!
  end

  private

  def item_params
    params.require(:item).permit(:id, :name, :code, :quantity, :description, :image, :status, :type, category_ids: [], publish_detail_attributes: [:id, :item_id, :isbn, :author, :publish_date])
  end
end
