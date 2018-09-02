require 'rails_helper'

describe CustomersController do
  let(:request_params) do
    {
      customer_file: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'customers.txt')),
      status: 0
    }
  end

  describe "#index" do
    context "allow to show upload button" do
      before :each do
        get :index
      end

      it { should render_template(:index) }
    end
  end

  describe "#customer_info" do
    context "allow to upload file and provide customers data" do
      before :each do
        post :customer_info, request_params
      end

      it { should render_template(:customer_info) }
    end

    context "Failure" do

      it "should redirect to index page when not file is uploaded" do
        post :customer_info
        expect(response).to redirect_to(customers_url)
      end
    end
  end
end
