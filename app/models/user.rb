class User < ActiveRecord::Base
  has_many :absorbs
  has_many :learning_boxes

  def self.find_by_omniauth auth_hash
    User.find_by_uid(auth_hash['uid'].to_s)
  end

  def self.create_with_omniauth! auth_hash
    create! do |user|
      user.name  = auth_hash['info'].name
      user.email = auth_hash['info'].email
      user.uid   = auth_hash['uid']
    end
  end

  def self.create_guest!
    create! do |user|
      user.name  = 'guest-' + (0..6).map{rand(9).to_s}.join
      user.uid   = SecureRandom.uuid
      user.guest = true
    end
  end

  def next_absorb! question_pool
    questions_needing_review =
      LearningBox.questions_needing_review(self, question_pool)

    next_question = sample_next(questions_needing_review)

    if next_question
      absorbs.create! do |absorb|
        absorb.question = next_question
      end
    else
      nil
    end
  end

  def next_review_time question_pool
    LearningBox.next_review_time(self, question_pool)
  end

  private

  def sample_next(question_pool)
    if Rails.env == 'test'
      return question_pool.first # deterministic results for testing
    end

    # TODO
    # maybe there is a better way to determine which question
    # should be asked next...
    question_pool.sample
  end

end
