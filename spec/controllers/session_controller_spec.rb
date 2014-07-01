require 'spec_helper'

describe SessionController, :type => :controller do

  describe "POST create" do

    let(:omniauth_hash) do
      {'info' => OpenStruct.new(email: 'john.doe@gmail.com', name: 'John Doe'),
       'uid' => 'some_unique_id'}
    end

    before do
      request.env['omniauth.auth'] = omniauth_hash
      post :create, :provider => 'developer'
    end

    it { expect(response.status).to eq(302) }
    it { expect(response).to redirect_to(root_url) }
    it { expect(assigns(:current_user)).to_not be_nil }
    it { expect(subject.current_user.email).to eq('john.doe@gmail.com') }

  end

end
