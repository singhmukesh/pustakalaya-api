class V1::AuthorsController < V1::ApplicationController

  def index
    @authors = PublishDetail.pluck(:author)
  end
end
