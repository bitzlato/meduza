class CreateCurrencies < ActiveRecord::Migration[6.1]
  def change
    create_table :currencies do |t|
      t.string :cc_code, null: false
      t.string :status, null: false, default: 'none'

      t.timestamps
    end

    add_index  :currencies, :cc_code, unique: true
  end
end
