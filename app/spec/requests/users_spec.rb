require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/:username" do
    let(:user) { create(:user) }
    context '存在するユーザ名の場合' do
      it 'ユーザのプロフィールが表示されること' do 
        get profile_path(user.name)
        expect(response).to have_http_status(:success)
        user = controller.instance_variable_get('@user')
        expect(user).to eq user
      end
    end
    context '存在しないユーザ名の場合' do
      it '404になること' do
        get profile_path('nouser')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
