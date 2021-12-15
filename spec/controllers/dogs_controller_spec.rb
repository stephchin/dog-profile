require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe '#index' do
    let(:user) { create(:user) }
    it 'displays recent dogs' do
      2.times { create(:dog, owner: user) }
      get :index
      expect(assigns(:dogs).size).to eq(2)
    end
  end
end
