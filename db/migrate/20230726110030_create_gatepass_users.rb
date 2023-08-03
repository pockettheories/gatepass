class CreateGatepassUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :gatepass_users do |t|
      t.string :username
      t.string :auth_type
      t.string :password_digest
      t.string :username_mapping
      t.string :rolename

      t.timestamps
    end
  end
end
