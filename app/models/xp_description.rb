class XpDescription < ApplicationRecord
  belongs_to :experience
  has_many :xp_items
end
