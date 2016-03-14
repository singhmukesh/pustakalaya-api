class V1::ItemsController < V1::ApplicationController
  before_action :set_item, only: [:show, :change_status, :update]
  before_action :authorize_item, only: [:create, :change_status]
  before_action :filter, only: [:index, :inactive]

  def index
    @items = @items.ACTIVE
  end

  def show
  end

  def create
    params[:item][:type].capitalize!
    @item = Item.new(item_params)
    @item.save!
  end

  def update
    @item.update!(item_params)
    render 'v1/items/create'
  end

  # @url v1/items/inactive
  # @action GET
  #
  # Provides listing of inactive books
  #
  # @response [Json]
  def inactive
    @items = @items.INACTIVE
    render 'v1/items/index'
  end

  # @url v1/items/change_status
  # @action GET
  #
  # Toggle status of the item
  #
  # @required id [Integer] Id of item whose status is to be change
  # @required status [Integer] 0 to Activate and 1 to Deactivate
  #
  # @response [Json]
  def change_status
    @item.update({status: Item.statuses[status]})
  end

  # @url v1/items/most_rated/
  # @action GET
  #
  # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  #
  # Return most rated item
  #
  # @response [Json] Item details
  def most_rated
    @items = Item.most_rated(params[:type])
    @items = paginate(@items)
  end

  # @url v1/items/most_leased/
  # @action GET
  #
  # @params type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  #
  # Return most leased item
  #
  # @response [Json] Item details
  def most_leased
    @items = Item.most_leased(params[:type])
    @items = paginate(@items)
  end

  private

  def authorize_item
    authorize Item
  end

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
    paginate_items
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

  def paginate_items
    @items = paginate(@items)
  end
end
