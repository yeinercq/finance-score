class AddMayorAccountReferencesToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_reference :accounts, :mayor_account, null: true, foreign_key: { to_table: :accounts }
    add_column :accounts, :level, :integer, null: false
  end
end
