class User < ApplicationRecord
  has_many :leases
  has_many :watches
  has_many :ratings
  has_many :reviews

  enum role: [:USER, :ADMIN]

  validates :name, :email, :uid, :role, presence: true
  validates_uniqueness_of :email, case_sensitive: false

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
