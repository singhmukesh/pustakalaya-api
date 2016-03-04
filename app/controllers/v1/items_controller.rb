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

  def listing
    type = params[:type]
    type.capitalize! if type.present?
    case type
    when Book.to_s
      @collection = Book
      @search_key = 'name_or_description_or_publish_detail_author_cont'
    when Device.to_s
      @collection = Device
      @search_key = 'name_or_description_cont'
    when Kindle.to_s
      @collection = Kindle
      @search_key = 'name_or_description_or_publish_detail_author_cont'
    else
      @collection = Item
      @search_key = 'name_or_description_cont'
    end
  end

  def filter
    listing
    @items = @collection.ransack({'s' => params[:sort], @search_key => params[:search]}).result
    @items = @items.find_by_category(params[:category_id]) if params[:category_id].present?
    @items = paginate(@items)
  end
end
