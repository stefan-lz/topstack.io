class CreateLearningBoxes < ActiveRecord::Migration
  def change
    create_table :learning_boxes do |t|
      t.integer  :user_id
      t.integer  :question_id
      t.integer  :level, :default => 3
      t.datetime :next_review

      t.timestamps
    end
  end
end
