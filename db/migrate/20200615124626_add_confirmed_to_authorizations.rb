class AddConfirmedToAuthorizations < ActiveRecord::Migration[6.0]
  def change
    add_column :authorizations, :confirmed, :boolean, null: false, default: false
  end
end
