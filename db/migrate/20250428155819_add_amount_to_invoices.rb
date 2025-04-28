class AddAmountToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :amount, :decimal
  end
end
