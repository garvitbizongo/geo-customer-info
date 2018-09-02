require 'rails_helper'

describe CustomersController do
  let(:sample_request) do
    {
      "customer_file"=> ""
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
end
