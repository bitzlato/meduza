class ChangeUniqueIndexForAddressAnalysis < ActiveRecord::Migration[6.1]
  def change
    remove_index :address_analyses, name: :index_address_analyses_on_address
    add_index :address_analyses, [:address, :cc_code], unique: true
  end
end
