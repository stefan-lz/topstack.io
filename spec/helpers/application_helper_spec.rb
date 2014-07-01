require 'spec_helper'

describe ApplicationHelper, :type => :helper do

  describe '#flash_class' do
    it { expect(flash_class :notice).to eq('success') }
    it { expect(flash_class 'notice').to eq('success') }

    it { expect(flash_class :alert).to eq('error') }
    it { expect(flash_class 'alert').to eq('error') }
  end

end
