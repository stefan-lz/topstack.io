require 'spec_helper'
require 'ostruct'

describe User do
  context 'omniauth' do
    subject { User }

    let(:uid) {'some_unique_id'}
    let(:existing_user_details) { {email: 'john.doe@gmail.com', 'uid' => uid} }
    let(:omniauth_hash) do
      {'info' => OpenStruct.new(email: 'john.doe@gmail.com', name: 'John Doe'),
       'uid' => uid}
    end

    describe '.find_by_omniauth' do
      subject { User.find_by_omniauth(omniauth_hash) }

      context 'when user exists' do
        before { FactoryGirl.create(:user, existing_user_details) }

        it { expect(subject).not_to be_nil }
        it { expect(subject.email).to eq('john.doe@gmail.com') }

        context 'with uid given as an integer' do
          let(:uid) { 123 }
          it { expect(subject).not_to be_nil }
        end
      end

      context 'when no user exists' do
        it { expect(subject).to be_nil }
      end

    end

    describe '.create_with_omniauth!' do
      subject { User.create_with_omniauth!(omniauth_hash).reload }

      context 'when user exists' do
        before { FactoryGirl.create(:user, existing_user_details) }

        it { expect{subject}.to raise_error(ActiveRecord::RecordNotUnique) }
      end

      context 'when no user exists' do
        it { expect(subject.name).to eq('John Doe') }
        it { expect(subject.email).to eq('john.doe@gmail.com') }
        it { expect(subject.uid).to eq('some_unique_id') }
        it { expect(subject.guest).to eq(false) }

        context 'with uid given as an integer' do
          let(:uid) { 123 }
          it { expect(subject.uid).to eq('123') }
        end
      end
    end
  end

  describe '.create_guest!' do
    context 'creating a single guest user' do
      subject { User.create_guest! }

      it { expect(subject.name).to start_with('guest') }
      it { expect(subject.email).to be_nil }
      it { expect(subject.uid).to_not be_nil }
      it { expect(subject.guest).to eq(true) }
    end
    context 'creating multiple guest users' do
      subject(:guests) { User.where(guest: true) }

      it { expect{100.times{User.create_guest!}}.to change{guests.count}.from(0).to(100) }
    end
  end

  describe '#next_absorb!', :vcr do
    subject(:user) { FactoryGirl.create(:user) }
    subject(:next_absorb) { user.next_absorb! question_pool }
    let(:question_pool) { ::TopStack::Serel.instance.questions }

    it { expect(next_absorb.question_id).to_not be_nil }
    it { expect(next_absorb.user_id).to eq(user.id) }

    context 'adds absorb to user collection' do
      subject(:absorbs) { user.absorbs }

      it 'can create a single absorb' do
        expect{next_absorb}.to change{absorbs.count}.from(0).to(1)
      end
      it 'can create the next 100 absorbs' do
        expect{100.times{user.next_absorb! question_pool}}.to change{absorbs.count}.from(0).to(100)
      end
    end

  end
end
