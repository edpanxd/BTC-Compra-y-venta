class CreateTransaccions < ActiveRecord::Migration[7.1]
  def change
    create_table :transaccions do |t|
      t.string :usuario
      t.string :monedaR
      t.string :monedaE
      t.decimal :cantidad
      t.decimal :pago
      t.decimal :precio, precision: 10, scale: 2
      t.string :tipo

      t.timestamps
    end
  end
end
