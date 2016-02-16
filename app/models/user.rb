class User < ApplicationRecord
  enum role: [:USER, :ADMIN]

  validates :name, :email, :uid, :role, presence: true
  validates_uniqueness_of :email, case_sensitive: false
end
