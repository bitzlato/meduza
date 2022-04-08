class CcCodeNotNullToAddressAnalyses < ActiveRecord::Migration[6.1]
  def change
    change_column_null :address_analyses, :cc_code, false
  end
end
