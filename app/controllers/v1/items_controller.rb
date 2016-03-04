class V1::ItemsController < V1::ApplicationController
  before_action :set_item, only: [:show, :change_status]
  before_action :filter, only: [:index, :inactivated]

  def index
    @items.ACTIVE
  end

  # @url v1/items/inactivated
  # @action GET
  #
  # Provides listing of inactivated books
  #
  # @response [Json]
  def inactivated
    @items = @items.INACTIVE
    render 'v1/items/index'
  end

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

  # @url v1/items/leased
  # @action GET
  #
  # Provides listing of leased items
  #
  # @response [Json]
  def leased
    @items = Item.where(id: leased_item_ids)
    @items = paginate(@items)
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

  def filter
    listing
    @items = @collection.ransack({'s' => params[:sort], @search_key => params[:search]}).result
    @items = @items.find_by_category(params[:category_id]) if params[:category_id].present?
    @items = paginate(@items)
  end

  def listing
    type = params[:type]
    type.capitalize! if type.present?
    case type
    when Book.to_s
      set_params(Book, 'name_or_description_or_publish_detail_author_cont')
    when Device.to_s
      set_params(Device, 'name_or_description_cont')
    when Kindle.to_s
      set_params(Kindle, 'name_or_description_or_publish_detail_author_cont')
    else
      set_params
    end
  end

  def set_params(collection = Item, search_key = 'name_or_description_cont')
    @collection = collection
    @search_key = search_key
  end

  def leased_item_ids
    type = params[:type]
    type.capitalize! if type.present?
    case type
    when Book.to_s
      Lease.ACTIVE.books.pluck(:item_id).uniq
    when Device.to_s
      Lease.ACTIVE.devices.pluck(:item_id).uniq
    else
      Lease.ACTIVE.pluck(:item_id).uniq
    end
  end
end
