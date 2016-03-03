class V1::BooksController < V1::ApplicationController
  before_action :filter

  def index
    @books = @books.ACTIVE
  end

  # @url v1/books/inactivated
  # @action GET
  #
  # Provides listing of inactivated books
  #
  # @response [Json]
  def inactivated
    @books = @books.INACTIVE
    render 'v1/books/index'
  end

  private

  def filter
    @books = Book.ransack({'s' => params[:sort], 'name_or_description_or_publish_detail_author_cont' => params[:search]}).result
    @books = @books.available if params[:available].present?
    @books = @books.find_by_category(params[:category_id]) if params[:category_id].present?
    @books = paginate(@books)
  end
end
