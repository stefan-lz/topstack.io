require 'spec_helper'
require 'ostruct'

describe LearningBox do
  let(:question_pool) { ::TopStack::Serel.instance.questions }
  let(:current_user) { FactoryGirl.create(:user) }

  describe '.questions_needing_review', :vcr do
    subject { LearningBox }

    it { expect(subject.questions_needing_review current_user, question_pool).to_not be_nil }
  end

  describe '.next_review_time', :vcr do
    subject { LearningBox }
    let(:review_time) { Time.new('2000-01-1') }

    before do
      FactoryGirl.create(:learning_box,
                          user_id:     current_user.id,
                          question_id: question_pool.first['question_id'],
                          next_review: review_time)
    end

    it { expect(subject.next_review_time current_user, question_pool).to eq(review_time) }
  end

  describe '#next_level' do

    context 'error when buried' do
      let(:score) { 'good' }
      subject { LearningBox.new(level: 'buried') }
      it { expect{ subject.next_level('good') }.to raise_error }
    end

    context 'good score' do
      let(:score) { 'good' }

      LearningBox.levels.reject{ |k,v| k == "buried" }.each do |level_name, level_value|
        it "should level up from #{level_name} to next level" do
          subject.level = level_name
          subject.next_level score
          if level_name != '2_years'
            expect(subject[:level]).to eq(level_value+1)
          else
            expect(subject[:level]).to eq(level_value)
          end
        end

        it "should update the next review time when at level #{level_name} to some time in the future" do
          subject.level = level_name
          subject.next_level score
          expect(subject.next_review).to be > Time.now.utc
        end
      end
    end

    context 'average score' do
      let(:score) { 'avg' }

      LearningBox.levels.reject{ |k,v| k == "buried" }.each do |level_name, level_value|
        it 'should not level up or down' do
          subject.level = level_name
          subject.next_level score
          expect(subject[:level]).to eq(level_value)
        end

        it "should update the next review time when at level #{level_name} to some time in the future" do
          subject.level = level_name
          subject.next_level score
          expect(subject.next_review).to be > Time.now.utc
        end
      end
    end

    context 'low score' do
      let(:score) { 'low' }

      LearningBox.levels.reject{ |k,v| k == "buried" || k }.each do |level_name, level_value|
        it "should level down from #{level_name} to next level" do
          subject.level = level_name
          subject.next_level score
          if level_name != '5_seconds'
            expect(subject[:level]).to eq(level_value-1)
          else
            expect(subject.level).to eq('5_seconds')
          end
        end

        it "should update the next review time when at level: #{level_name} to now" do
          subject.level = level_name
          subject.next_level score
          expect(subject.next_review).to eq(Time.now.utc)
        end
      end
    end
  end

  describe '#absorb_options' do
    subject { LearningBox.new(level: level) }

    context 'level: 5_seconds' do
      let(:level) { '5_seconds' }

      it { expect(subject.absorb_options).to eq(
        {low_score:     '5 seconds',
         average_score: nil,
         good_score:    '25 seconds'} ) }
    end

    context 'level: 2_minutes' do
      let(:level) { '2_minutes' }

      it { expect(subject.absorb_options).to eq(
        {low_score:     '25 seconds',
         average_score: '2 minutes',
         good_score:    '10 minutes'} ) }
    end

    context 'level: 2_years' do
      let(:level) { '2_years' }

      it { expect(subject.absorb_options).to eq(
        {low_score:     '4 months',
         average_score: '2 years',
         good_score:    '2 years'} ) }
    end

  end
end
