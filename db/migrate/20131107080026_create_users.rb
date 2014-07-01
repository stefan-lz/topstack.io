class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :uid, null: false
      t.boolean :guest, default: false

      t.timestamps
    end
  end
end
