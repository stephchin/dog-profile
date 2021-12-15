class Dog < ApplicationRecord
  has_many_attached :images

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :likes, dependent: :destroy
end
