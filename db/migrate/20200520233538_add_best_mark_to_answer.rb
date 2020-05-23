class AddBestMarkToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best_mark, :boolean, default: false
  end
end
