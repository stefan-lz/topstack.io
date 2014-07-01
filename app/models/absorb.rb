require 'topstack/serel'

class Absorb < ActiveRecord::Base
  belongs_to :user
  enum score: %w(bury low avg good)

  validates :question_id, presence: true, numericality: { only_integer: true }

  #TODO: user_id should be a foreign key
  validates :user_id, presence: true

  attr_reader :question

  def question=(question)
    @question = question
    self.question_id = question ? question["question_id"] : nil
  end

  def answer
    return nil if @question == nil

    @answer ||=
      begin
        ::TopStack::Serel.instance.answer(@question['accepted_answer_id'])
      end
  end

  def learning_box
    @learning_box ||=
      begin
        LearningBox.find_or_create_by( user_id:     self.user_id,
                                       question_id: self.question_id )
      end
  end
end
