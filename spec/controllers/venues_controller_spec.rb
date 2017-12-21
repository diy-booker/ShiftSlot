require 'rails_helper'

RSpec.describe VenuesController, type: :controller do
  let(:org) { FactoryGirl.create :organization}
  let(:user) { FactoryGirl.create(:user) }
  let(:venue) { FactoryGirl.create(:venue) }
  let(:show) { FactoryGirl.create(:show) }
  before(:each) do
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
  describe '#index' do
    it 'assigns the @venues variable' do
      get :index, params: { organization_id: org.id }
      expect(assigns(:venues)).to be_an(ActiveRecord::Relation)
    end
    it 'responds with a status of 200' do
      get :index, params: { organization_id: org.id }
      expect(response.status).to eq(200)
    end
    it 'renders the index page' do
      expect(get :index, params: { organization_id: org.id }).to render_template(:index)
    end
  end
  describe '#show' do
    it 'assigns the @venue variable' do
      get :show, params: {id: venue.id}
      expect(assigns(:venue)).to eq(venue)
    end
    it 'assigns the @shows variable' do
      get :show, params: {id: venue.id}
      expect(assigns(:shows)).to all(be_a(Show))
    end
    it 'responds with a status of 200' do
      get :show, params: {id: venue.id}
      expect(response.status).to eq(200)
    end
    it 'renders the index page' do
      expect(get :show, params: {id: venue.id}).to render_template(:show)
    end
  end
  describe 'new' do
    before(:each) do
      get :new
    end
    it 'assigns the @orgs variable' do
      expect(assigns[:orgs]).to eq(user.all_admin_orgs)
    end
    it 'assigns the @venue variable' do
      expect(assigns[:venue]).to be_a_new(Venue)
    end
    it 'responds with a status of 200' do
      expect(response.status).to eq(200)
    end
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end
  describe 'create' do
    it 'responds with a status of 302'
    context 'on success' do
      it 'saves the new venue to the database'
      it 'redirects to the organization_venues_path'
    end
    context 'on failure' do
      it 'responds with an error message in flash'
      it 'redirects to the new_venue_path'
    end
  end
end
