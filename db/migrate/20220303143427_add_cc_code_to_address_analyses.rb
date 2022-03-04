class AddCcCodeToAddressAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_column :address_analyses, :cc_code, :string
  end
end
