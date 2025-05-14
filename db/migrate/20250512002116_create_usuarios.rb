class CreateUsuarios < ActiveRecord::Migration[7.1]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :cuenta
      t.decimal :saldo
      t.decimal :cartera
      t.timestamps
    end
  end
end
