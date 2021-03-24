class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :created_at, :updated_at
  has_many :books
end
