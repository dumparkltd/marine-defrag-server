require "rails_helper"
require "json"

RSpec.describe ActorCategoriesController, type: :controller do
  let(:category) { FactoryBot.create(:category) }
  let(:actor) { FactoryBot.create(:actor) }
  let!(:actortype_taxonomy) do
    FactoryBot.create(:actortype_taxonomy, actortype: actor.actortype, taxonomy: category.taxonomy)
  end

  describe "Get index" do
    subject { get :index, format: :json }

    context "when not signed in" do
      it { expect(subject).to be_forbidden }
    end
  end

  describe "Get show" do
    let(:actor_category) { FactoryBot.create(:actor_category, category: category, actor: actor) }
    subject { get :show, params: {id: actor_category}, format: :json }

    context "when not signed in" do
      it { expect(subject).to be_forbidden }
    end
  end

  describe "Post create" do
    context "when not signed in" do
      it "not allow creating a actor_category" do
        post :create, format: :json, params: {actor_category: {actor_id: 1, category_id: 1}}
        expect(response).to be_unauthorized
      end
    end

    context "when signed in" do
      let(:guest) { FactoryBot.create(:user) }
      let(:user) { FactoryBot.create(:user, :manager) }

      subject do
        post :create,
          format: :json,
          params: {
            actor_category: {
              actor_id: actor.id,
              category_id: category.id
            }
          }
      end

      it "will not allow a guest to create a actor_category" do
        sign_in guest
        expect(subject).to be_forbidden
      end

      it "will allow a manager to create a actor_category" do
        sign_in user
        expect(subject).to be_created
      end

      it "will return an error if params are incorrect" do
        sign_in user
        post :create, format: :json, params: {actor_category: {description: "desc only", taxonomy_id: 999}}
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "Delete destroy" do
    let(:actor_category) { FactoryBot.create(:actor_category, category: category, actor: actor) }
    subject { delete :destroy, format: :json, params: {id: actor_category} }

    context "when not signed in" do
      it "not allow deleting a actor_category" do
        expect(subject).to be_unauthorized
      end
    end

    context "when user signed in" do
      let(:guest) { FactoryBot.create(:user) }
      let(:user) { FactoryBot.create(:user, :manager) }

      it "will not allow a guest to delete a actor_category" do
        sign_in guest
        expect(subject).to be_forbidden
      end

      it "will allow a manager to delete a actor_category" do
        sign_in user
        expect(subject).to be_no_content
      end
    end
  end
end
