class AddAuthorToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :author, index: true, null: false, foreign_key: { to_table: :users }
  end
end
