require 'spec_helper'

describe NavHelper, :type => :helper do

  let (:previous_top) {nil}
  let (:previous_tags) {nil}
  let (:previous_time_range) {nil}

  before do
    @top = previous_top
    @tags = previous_tags
    @time_range = previous_time_range
  end

  describe '#build_path' do
    let (:new_top) {nil}
    let (:new_tags) {nil}
    let (:new_time_range) {nil}
    let (:new_options) { {top: new_top, tags: new_tags, time_range: new_time_range} }

    it { expect(build_path(new_options)).to eq('/top-10') }

    context 'top' do
      context 'with previous' do
        let (:previous_top) {50}

        it { expect(build_path(new_options)).to eq('/top-50') }

        context 'and new' do
          let (:new_top) {100}

          it { expect(build_path(new_options)).to eq('/top-100') }
        end
      end
    end

    context 'tags' do
      context 'with previous' do
        let (:previous_tags) { %w(javascript ruby) }

        it { expect(build_path(new_options)).to eq('/top-10/javascript+ruby') }
        context 'and new' do
          let (:new_tags) { %w(html) }

          it { expect(build_path(new_options)).to eq('/top-10/html') }
        end

        context 'and new nil value' do
          let (:new_tags) { 'nil' }

          it { expect(build_path(new_options)).to eq('/top-10') }
        end
      end
    end

    context 'time-range' do
      context 'with previous' do
        let (:previous_time_range) {
          {time_from: (Time.now - 7.days).to_i, time_to: Time.now.to_i}
        }

        it { expect(build_path(new_options)).to eq('/top-10/this-week') }

        context 'and new' do
          let (:new_time_range) { 'this-month' }

          it { expect(build_path(new_options)).to eq('/top-10/this-month') }
        end

        context 'and new nil value' do
          let (:new_time_range) { 'nil' }

          it { expect(build_path(new_options)).to eq('/top-10') }
        end
      end
    end

    context 'all' do
      context 'with previous' do
        let (:previous_top) {50}
        let (:previous_tags) { %w(javascript ruby) }
        let (:previous_time_range) {
          {time_from: (Time.now - 7.days).to_i, time_to: Time.now.to_i}
        }

        it { expect(build_path(new_options)).to eq('/top-50/javascript+ruby/this-week') }

        context 'and new' do
          let (:new_top) {100}
          let (:new_tags) { %w(html) }
          let (:new_time_range) { 'this-month' }

          it { expect(build_path(new_options)).to eq('/top-100/html/this-month') }
        end
      end
    end
  end

  describe '#humanized_tags' do
    let (:previous_tags) { %w(javascript ruby) }

    it { expect(humanized_tags).to eq('javascript,ruby') }
  end

  describe '#humanized_time_range' do

    context 'this-week' do
      let (:previous_time_range) {
            { time_from: (Time.now - 7.days).to_i,
              time_to:   Time.now.to_i } }

      it { expect(humanized_time_range).to eq('this-week') }
    end

    context 'this-month' do
      let (:previous_time_range) {
            { time_from: (Time.now - 31.days).to_i,
              time_to:   Time.now.to_i } }

      it { expect(humanized_time_range).to eq('this-month') }
    end
  end
end
