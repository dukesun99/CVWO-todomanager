class Team < ApplicationRecord
  has_many :tasks, as: :taskable
  has_and_belongs_to_many :users
  validates :name, presence:true, length: { maximum: 100 }
  validates :invition_code, presence: true, length: { maximum: 20, minimum: 5 },
                    uniqueness: { case_sensitive: false }
end
