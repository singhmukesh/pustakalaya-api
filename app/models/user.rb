class User < ApplicationRecord
  has_many :leases
  has_many :watches
  has_many :ratings
  has_many :reviews

  enum role: [:USER, :ADMIN]

  validates :name, :email, :uid, :role, presence: true
  validates_uniqueness_of :email, case_sensitive: false

  # Provides whether the item is leases by user
  #
  # @params item_id [Item::ActiveRecord_Relation id attribute]
  #
  # @return [Boolean]
  def leased?(item_id)
    leases.ACTIVE.find_by(item_id: item_id).present?
  end

  # Provides whether the item is in Watchlist of user
  #
  # @params item_id [Item::ActiveRecord_Relation id attribute]
  #
  # @return [Boolean]
  def watched?(item_id)
    watches.ACTIVE.find_by(item_id: item_id).present?
  end

  # Provides the collection of users
  #
  # @params item_type [String] expected to be value of Item::ActiveRecord_Relation type attribute
  #
  # @return [User::ActiveRecord_Relation Collection]
  def self.with_most_leases(type = Book.to_s)
    raise ActiveRecord::StatementInvalid unless [Book.to_s, Device.to_s].include? type
    self.joins(leases: :item).group('leases.user_id').order('count(leases.user_id) desc').where('items.type = ?', type)
  end

  class << self
    # Verify whether the user details is present in system database and if not present create the new user with available details
    #
    # @params auth [HTTParty::Response], Hash containing response of Google Oauth validation
    #
    # @return [User::ActiveRecord_Relation], Active Record Object containing the user details
    def find_user(auth)
      user = User.find_by(uid: auth['id'])
      unless user
        user = User.create(name: auth['name'],
        email: auth['email'],
        image: auth['picture'],
        uid: auth['id'])
      end
      user
    end
  end
end
