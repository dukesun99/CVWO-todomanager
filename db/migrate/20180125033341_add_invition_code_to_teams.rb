class AddInvitionCodeToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :invition_code, :string
  end
end
