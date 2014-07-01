require 'spec_helper'

describe ApplicationController, :type => :controller do

  describe '#auth_path' do

    it 'should provide the /auth/developer url when in development' do
      allow(Rails).to receive(:env).and_return 'development'
      expect(subject.auth_path).to eq('/auth/developer')
    end

    it 'should provide the /auth/developer url when in test' do
      allow(Rails).to receive(:env).and_return 'test'
      expect(subject.auth_path).to eq('/auth/developer')
    end

    it 'should provide the /auth/stackexchange when in production' do
      allow(Rails).to receive(:env).and_return 'production'
      expect(subject.auth_path).to eq('/auth/stackexchange')
    end

  end
end
