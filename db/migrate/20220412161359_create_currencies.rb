class CreateCurrencies < ActiveRecord::Migration[6.1]
  def up
    create_table :currencies do |t|
      t.string :cc_code, null: false
      t.string :status, null: false, default: 'skip'

      t.timestamps
    end

    add_index  :currencies, :cc_code, unique: true

    OUR_CODES.each do |cc_code|
      Currency.create!(cc_code: cc_code)
    end
  end

  def down
    drop_table :currencies
  end
end
