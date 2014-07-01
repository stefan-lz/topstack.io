class CreateAbsorbs < ActiveRecord::Migration
  def change
    create_table :absorbs do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :score

      t.datetime :answer_revealed_at
      t.datetime :scored_at

      t.timestamps
    end
  end
end
