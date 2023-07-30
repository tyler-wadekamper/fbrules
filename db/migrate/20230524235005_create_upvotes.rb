class CreateUpvotes < ActiveRecord::Migration[7.0]
  def change
    create_table :upvotes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
