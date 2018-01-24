class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :detail
      t.datetime :due_date
      t.integer :importance
      t.string :category
      t.references :taskable, :polymorphic => true

      t.timestamps
    end
  end
end
