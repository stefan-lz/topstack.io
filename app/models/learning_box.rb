class LearningBoxBuriedError < StandardError; end

class LearningBox < ActiveRecord::Base
  belongs_to :user

  scope :buried, -> { where(level: 0) }
  scope :still_learning, -> { where(level: [1,2,3,4]) }
  scope :short_term, -> { where(level: [5,6,7,8]) }
  scope :long_term, -> { where(level: [9,10,11]) }

  before_create :default_next_review

  #http://en.wikipedia.org/wiki/Pimsleur_language_learning_system
  enum level: %w(buried 5_seconds 25_seconds 2_minutes 10_minutes 1_hour 5_hours 1_day 5_days 25_days 4_months 2_years)

  def self.questions_needing_review(user, question_pool)
    learning_boxes = where( user_id: user.id,
      question_id: question_pool.map{ |q| q['question_id'] })

    not_needing_review = learning_boxes.select{ |lb|
      (lb.next_review.nil? ||
      lb.next_review > Time.now) ||
      lb.level == 'buried' }.map(&:question_id)

    question_pool.reject{ |q| not_needing_review.include? q['question_id'].to_i }
  end

  def self.next_review_time(user, question_pool)
    #TODO: write some specs and features around this.
    learning_box = where( user_id:     user.id,
                          question_id: question_pool.map{ |q|
                                         q['question_id'] })
                  .where.not(level:    'buried')
                  .where.not(next_review: nil)
                  .order(next_review: :asc).first

    learning_box.next_review if learning_box
  end

  def next_level score
    if self.level == 'buried'
      raise LearningBoxBuriedError, 'cannot score when buried'
    end

    case score
    when 'bury'
      self.level = 'buried'
      self.next_review = nil
    when 'low'
      unless self.level == '5_seconds'
        self.level = self[:level] -= 1
      end
      self.next_review = Time.now
    when 'avg'
      # level = unchanged
      self.next_review = Time.now + level_to_time_range(self.level)
    when 'good'
      unless self.level == '2_years'
        self.level = self[:level] + 1
      end
      self.next_review = Time.now + level_to_time_range(self.level)
    end

    self.save!
  end

  def absorb_options
    @absorb_options ||=
      begin
        Hash[{ low_score:     self[:level] > 1  ? self[:level] - 1 : 1,
               average_score: self[:level] > 1  ? self[:level]     : nil,
               good_score:    self[:level] < 11 ? self[:level] + 1 : 11  }
             .map { |k,v| [k, v.nil? ? v : self.class.levels.invert[v].humanize]}]
      end
  end

  private

  def level_to_time_range level
    { '5_seconds'    => 5.seconds,
      '25_seconds'   => 25.seconds,
      '2_minutes'    => 2.minutes,
      '10_minutes'   => 10.minutes,
      '1_hour'  => 1.hour,
      '5_hours' => 5.hours,
      '1_day'   => 1.day,
      '5_days'   => 5.days,
      '25_days'  => 25.days,
      '4_months' => 4.months,
      '2_years'   => 2.years }[level]
  end

  def default_next_review
    if self.level != 'buried' && self.next_review.nil?
      self.next_review = Time.now 
    end
  end
end
