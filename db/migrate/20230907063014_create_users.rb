class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.index ["email"], name: "index_users_on_email", unique: true
      t.string :password_digest
      t.boolean :gender
      t.date :date_of_birth
      t.string :phone_number
      t.string :address
      t.boolean :is_admin, default: false
      t.boolean :activated, default: false
      t.string :activation_digest
      t.datetime :activated_at

      t.timestamps
    end
  end
end
