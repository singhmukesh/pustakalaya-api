class V1::CategoriesController < V1::ApplicationController

  def index
    @categories = if group == Category.groups.keys[Category.groups[:BOOK]]
                    Category.where(group: Category.groups[:BOOK])
                  elsif group == Category.groups.keys[Category.groups[:DEVICE]]
                    Category.where(group: Category.groups[:DEVICE])
                  else
                    Category.all
                  end
  end

  private

  def group
    params[:group].upcase if params[:group].present?
  end
end
