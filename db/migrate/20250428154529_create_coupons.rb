class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.references :merchant, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false
      t.integer :discount_type, null: false
      t.decimal :discount_value, null: false, precision: 8, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end