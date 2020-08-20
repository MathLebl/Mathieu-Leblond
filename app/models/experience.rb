class Experience < ApplicationRecord
  belongs_to :user
  has_many :xp_descriptions, dependent: :destroy
  accepts_nested_attributes_for :xp_descriptions, allow_destroy: true
  has_many :xp_items, through: :xp_descriptions, dependent: :destroy
  accepts_nested_attributes_for :xp_items, allow_destroy: true
end
