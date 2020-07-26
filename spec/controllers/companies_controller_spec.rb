require 'rails_helper'

describe CompaniesController do
  render_views

  describe 'GET #edit' do
    it 'renders edit company page' do
      login_admin(Package::FREE)

      get :edit, id: current_user.company.id

      expect(response.status).to eq(200)
      expect(response).to render_template(:edit)
      expect(response.body).to have_text('Edit Company')
    end
  end

  describe 'GET #show' do
    context 'when company id exists' do
      it 'renders company page' do
        login_admin(Package::FREE)

        get :show, id: current_user.company.id

        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
        expect(response.body).to have_text(current_user.company.website)
      end
    end
    context "when company id doesn't exist" do
      it 'redirects to root page' do
        get :show, id: 2

        expect(response.status).to eq(302)
        expect(response).to redirect_to '/'
      end
    end
  end
end