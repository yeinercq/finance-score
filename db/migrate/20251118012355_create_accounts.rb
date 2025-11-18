class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.integer :number
      t.string :name
      t.integer :nature
      t.integer :type

      t.timestamps
    end
  end
end
