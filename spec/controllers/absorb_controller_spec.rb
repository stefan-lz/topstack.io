require 'spec_helper'

describe AbsorbController, :type => :controller do

  let(:current_user) { FactoryGirl.create(:user) }

  before do
    subject.current_user = current_user
  end

  describe "GET index", :vcr do

    before do
      get :index
    end

    it { expect(response.status).to eq(200) }
    it { expect(response).to render_template('show') }
    it { expect(assigns(:absorb)).to_not be_nil }
  end

  describe "GET index/:top/:unknown_filter", :vcr do
    let(:top) { 'top-10' }
    let(:tags) { 'javascript+ruby' }
    let(:time_range) { 'this-week' }

    before do
      get :index, params
    end

    context 'with tags' do
      let(:params) { {top: top, unknown_filter: tags} }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('show') }
      it { expect(assigns(:absorb)).to_not be_nil }
    end

    context 'with time_range' do
      let(:params) { {top: top, unknown_filter: time_range} }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('show') }
      it { expect(assigns(:absorb)).to_not be_nil }
    end

    context 'with invalid param' do
      let(:params) { {top: top, unknown_filter: 'no-good'} }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(:file => "#{Rails.root}/public/404.html") }
    end
  end

  describe "GET index/:top/:tags/:time_range", :vcr do

    let(:top) { 'top-50' }
    let(:tags) { 'javascript+ruby' }
    let(:time_range) { 'this-month' }
    let(:params) { {top: top, tags: tags, time_range: time_range} }

    before do
      get :index, params
    end

    it { expect(response.status).to eq(200) }
    it { expect(response).to render_template('show') }
    it { expect(assigns(:absorb)).to_not be_nil }

    context 'bad top param' do
      let(:top) { 'not-top-10' }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(:file => "#{Rails.root}/public/404.html") }
    end

    context 'bad tags param' do
      let(:tags) { 'non-existant-tag' }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(:file => "#{Rails.root}/public/404.html") }
    end

    context 'bad time-range' do
      let(:time_range) { 'not-a-time-range' }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(:file => "#{Rails.root}/public/404.html") }
    end

  end

  describe 'GET index - with no results', :vcr do

    before do
      Timecop.freeze(Time.local(1990))
      get :index, { time_range: 'this-week' }
    end

    it { expect(response.status).to eq(200) }
    it { expect(response).to render_template('no_results') }
    it { expect(assigns(:absorb)).to be_nil }
  end

  describe "GET show/:id", :vcr do

    before do
      question_pool = ::TopStack::Serel.instance.questions
      absorb = current_user.next_absorb! question_pool
      get :show, id: absorb.id
    end

    it { expect(response.status).to eq(200) }
    it { expect(response).to render_template('show') }
    it { expect(assigns(:absorb)).to_not be_nil }
  end

  describe "PUT update/:id", :vcr do
    let(:question_pool) { ::TopStack::Serel.instance.questions }
    let(:absorb) { current_user.next_absorb! question_pool }
    let(:learning_box) { absorb.learning_box }
    let(:current_path_in_session) { nil }
    let(:score) { 0 }

    before do
      session['current_path'] = current_path_in_session
      post :update, id: absorb.id, score: score, answer_revealed_at: Time.now - 10.seconds
    end

    describe 'scoring' do

      it { expect(absorb.reload.scored_at).to be_a Time }
      it { expect(absorb.reload.answer_revealed_at).to be_a Time }
      it { expect(learning_box.reload).to_not be_nil }

      context 'bury' do
        let(:score) { 0 }
        it { expect(absorb.reload.score).to eq('bury') }
        it { expect(learning_box.reload.level).to eq('buried') }
        it { expect(learning_box.reload.next_review).to be_nil }
      end

      context 'low score' do
        let(:score) { 1 }
        it { expect(absorb.reload.score).to eq('low') }
        it { expect(learning_box.reload.level).to eq('25_seconds') }
        it { expect(learning_box.reload.next_review).to be_a Time }
        it { expect(learning_box.reload.next_review.to_s).to eq(Time.now.utc.to_s) }
      end

      context 'average score' do
        let(:score) { 2 }
        it { expect(absorb.reload.score).to eq('avg') }
        it { expect(learning_box.reload.level).to eq('2_minutes') }
        it { expect(learning_box.reload.next_review).to be_a Time }
        it { expect(learning_box.reload.next_review.to_s).to eq((Time.now + 2.minutes).utc.to_s) }
      end

      context 'good score' do
        let(:score) { 3 }
        it { expect(absorb.reload.score).to eq('good') }
        it { expect(absorb.reload.learning_box.level).to eq('10_minutes') }
        it { expect(absorb.reload.learning_box.next_review).to be_a Time }
        it { expect(absorb.reload.learning_box.next_review.to_s).to eq((Time.now + 10.minutes).utc.to_s) }
      end
    end

    it { expect(response.status).to eq(302) }
    it { expect(assigns(:absorb)).to_not be_nil }

    context 'no current path in session' do
      it { expect(response).to redirect_to('/') }
    end

    context 'existing path in session' do
      let(:current_path_in_session) { '/top-10/ruby' }
      it { expect(response).to redirect_to('/top-10/ruby')}
    end

  end
end
