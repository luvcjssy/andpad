class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :created_at, :updated_at
  belongs_to :author
end
