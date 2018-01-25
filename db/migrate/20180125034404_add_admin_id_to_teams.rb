class AddAdminIdToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :admin_id, :integer
  end
end
