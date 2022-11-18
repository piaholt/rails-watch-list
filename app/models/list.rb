class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks, dependent: :destroy
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
