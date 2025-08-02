require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "POST #create" do
    let(:ip_address) { "0.0.0.0" }

    before do
      allow(request).to receive(:remote_ip).and_return(ip_address)
    end

    it "create new search" do
      expect { post :create, params: { query: "ruby" }, as: :json}.to change(Search, :count).by(1)
      expect(Search.last.query).to eq("ruby")
      expect(Search.last.ip_address).to eq(ip_address)
    end

    it "updates the existing search if it was made less than 1 minute ago" do
      old_search = Search.create!(query: "old", ip_address: ip_address, updated_at: 57.seconds.ago)

      expect {
        post :create, params: { query: "new" }, as: :json
      }.not_to change(Search, :count)

      expect(old_search.reload.query).to eq("new")
    end
  end

  describe "GET #analytics" do
    let(:ip_address) { "0.0.0.0" }

    before do
      allow(request).to receive(:remote_ip).and_return(ip_address)
      Search.create!(query: "test1", ip_address: ip_address)
      Search.create!(query: "test2", ip_address: ip_address)
      Search.create!(query: "test1", ip_address: ip_address)
      Search.create!(query: "test3", ip_address: ip_address)
    end

    it "return top queries based on ip" do
      get :analytics, format: :json
      json = JSON.parse(response.body)

      expect(json["test1"]).to eq(2)
      expect(json["test2"]).to eq(1)
      expect(json["test3"]).to eq(1)
    end
  end
end
