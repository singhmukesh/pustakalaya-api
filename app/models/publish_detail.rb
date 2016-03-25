class PublishDetail < ApplicationRecord
  belongs_to :item

  validates :author, presence: true
  validates_date :publish_date, on_or_before: lambda { Date.current }, allow_nil: true

  # Retrieves goodreads information using isbn
  #
  # @return [Hashie::Mash]
  def goodreads
    client = Goodreads.new(Goodreads.configuration)
    isbn = self.isbn.gsub("-", "")
    return nil unless isbn.present?
    begin
      return client.book_by_isbn(isbn)
    rescue
      nil
    end
  end

end
