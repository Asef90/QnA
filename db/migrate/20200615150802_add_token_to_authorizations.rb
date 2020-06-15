class AddTokenToAuthorizations < ActiveRecord::Migration[6.0]
  def change
    add_column :authorizations, :token, :integer
  end
end
