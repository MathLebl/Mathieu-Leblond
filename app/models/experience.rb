class Experience < ApplicationRecord
  belongs_to :user
  has_one :xp_description, dependent: :destroy
  accepts_nested_attributes_for :xp_description, allow_destroy: true
end
