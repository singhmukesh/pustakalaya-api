class V1::BooksController < V1::ApplicationController

  # @url v1/books/available
  # @action GET
  #
  # Provides listing of available books
  #
  # @response [Json]
  def available
    @books = Book.ACTIVE.available.ransack({'s' => params[:sort], 'name_or_description_or_publish_detail_author_cont' => params[:search]}).result
    @books = @books.find_by_category(params[:category_id]) if params[:category_id].present?
    @books = paginate(@books)
  end

  # @url v1/books/leased
  # @action GET
  #
  # Provides listing of leased books
  #
  # @response [Json]
  def leased
    book_ids = Lease.ACTIVE.books.pluck(:item_id).uniq
    @books = Book.where(id: book_ids)
    @books = paginate(@books)
  end
end
