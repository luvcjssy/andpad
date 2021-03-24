class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true

  scope :search, -> (keyword) { joins(:author).where("authors.name ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present? }
end
