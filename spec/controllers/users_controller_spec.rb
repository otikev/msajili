require 'rails_helper'

describe UsersController do
  render_views
  
  describe 'GET #new' do
    it 'renders page with applicant signup form' do
      get :new
      expect(response).to render_template(:new)
      expect(response.body).to have_text('Signup')
    end
  end
  
  describe 'POST #create' do
    before do
      @existing_user = create(:applicant)
      
      @user_params = Hash.new
      @user_params[:role] = Role.applicant
      @user_params[:first_name] = 'Kevin'
      @user_params[:last_name] = 'Otieno'
      @user_params[:email] = '123@test.com'
      @user_params[:country] = 'KE'
      @user_params[:city] = 'Nairobi'
      @user_params[:password] = '123456'
      @user_params[:password_confirmation] = '123456'
    end
    
    context 'when details are valid' do
      it 'displays the roles page with message' do
        post :create, user: @user_params
        
        expect(response.status).to eq(302)
        expect(response).to redirect_to '/role'
        expect(flash[:success]).to match(/^Sign up successful. An activation email has been sent to/)
      end
    end
    
    context 'when email format is invalid' do
      it 'displays error message' do
        prms = @user_params
        prms[:email] = 'invalidemail'
        post :create, user: prms
        
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(response.body).to have_text('Email is invalid')
      end
    end
    
    context 'when email is taken' do
      it 'displays error message' do
        prms = @user_params
        prms[:email] = @existing_user.email
        post :create, user: prms
        
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(response.body).to have_text('Email has already been taken')
      end
    end
  end
  
  describe 'GET #new_recruiter' do
    context 'when package is free' do
      it 'redirect and show error message' do
        login_admin(Package::FREE)

        get :new_recruiter, company_id: current_user.company.id

        expect(response.status).to eq(302)
        expect(response).to redirect_to '/dashboard'
        expect(flash[:danger]).to match(/^You cannot add recruiters on the free package./)
      end
    end

    context 'when package is on-demand' do
      it 'renders page with recruiter signup form' do
        login_admin(Package::ON_DEMAND)

        get :new_recruiter, company_id: current_user.company.id

        expect(response.status).to eq(200)
        expect(response).to render_template(:new_recruiter)
        expect(response.body).to have_text('New Recruiter')
      end
    end
    context 'when package is premium' do
      it 'renders page with recruiter signup form' do
        login_admin(Package::PREMIUM)

        get :new_recruiter, company_id: current_user.company.id

        expect(response.status).to eq(200)
        expect(response).to render_template(:new_recruiter)
        expect(response.body).to have_text('New Recruiter')
      end
    end
  end
  
  describe 'GET #list' do
    context 'when user is admin' do
      it 'returns a user list' do
        login_admin(Package::FREE)
        
        get :list
        expect(response.status).to eq(200)
        expect(response.body).to have_text("\"sEcho\":")
      end
    end
    
    context 'when no user logged in' do
      it 'redirect' do
        get :list
        expect(response.status).to eq(302)
      end
    end
    
    context 'when applicant logged in' do
      it 'redirect' do
        login_applicant
        get :list
        expect(response.status).to eq(302)
      end
    end
  end
  
end

