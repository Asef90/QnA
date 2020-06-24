class CreateAuthorizations < ActiveRecord::Migration[6.0]
  def change
    create_table :authorizations do |t|
      t.references :user
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :authorizations, [:provider, :uid], unique: true
  end
end
