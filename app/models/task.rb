class Task < ApplicationRecord
  attr_accessor :cat_name
  belongs_to :taskable, :polymorphic => true
  #validates :category_id, presence: true
  validates :due_date, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  #validates :taskable_id, presence: true

end
