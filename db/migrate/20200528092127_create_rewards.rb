class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.references :question, null: false, foreign_key: true
      t.references :user

      t.timestamps
    end
  end
end
