class V1::BooksController < V1::ApplicationController

  def index
    books = Book.ransack({'s' => params[:sort], 'name_or_description_or_publish_detail_author_cont' => params[:search]})
    @books = paginate(books)
  end
end
