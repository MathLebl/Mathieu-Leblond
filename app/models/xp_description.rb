class XpDescription < ApplicationRecord
  belongs_to :experience
  has_many :xp_items, dependent: :destroy
  accepts_nested_attributes_for :xp_items, allow_destroy: true
end
