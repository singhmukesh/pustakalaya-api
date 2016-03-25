class PublishDetail < ApplicationRecord
  belongs_to :item

  validates :author, presence: true
  validates_date :publish_date, on_or_before: lambda { Date.current }, allow_nil: true

  # Retrieves goodreads information using isbn
  #
  # @return [Hashie::Mash]
  def goodreads
    return nil unless self.isbn.present?
    client = Goodreads.new(Goodreads.configuration)
    isbn = self.isbn.gsub("-", "")
    begin
      return client.book_by_isbn(isbn)
    rescue
      nil
    end
  end

end
