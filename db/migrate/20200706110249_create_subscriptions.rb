class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscriptable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :subscriptions, [:subscriptable_type, :subscriptable_id, :user_id],
                              name: 'subscriptions_index',
                              unique: true
  end
end
