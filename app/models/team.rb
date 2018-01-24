class Team < ApplicationRecord
  has_many :tasks, as: :taskable
  has_and_belongs_to_many :users
  validates :name, presence:true, length: { maximum: 100 }

end
