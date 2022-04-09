class CreateDangerAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :danger_addresses do |t|
      t.references :analyzed_user, null: false, foreign_key: true
      t.string :address, null: false
      t.string :cc_code, null: false

      t.timestamps
    end

    add_index :danger_addresses, [:analyzed_user_id, :cc_code, :address], unique: true, name: :danger_addresses_uniq_index
    add_index :danger_addresses, :address
  end
end
