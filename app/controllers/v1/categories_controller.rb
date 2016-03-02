class V1::CategoriesController < V1::ApplicationController

  def index
    @categories = Category.list(params[:group])
  end
end
