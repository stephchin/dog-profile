class AddOwnerToDogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :dogs, :owner, foreign_key: { to_table: :users }
  end
end
