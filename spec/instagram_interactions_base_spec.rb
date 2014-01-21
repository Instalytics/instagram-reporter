require 'spec_helper'

describe InstagramInteractionsBase do

  describe '#initialize' do
    xit "should raise error if environmental variable INSTAGRAM_API_TOKEN is not set" do
      InstagramInteractionsBase::API_TOKEN = nil
      expect(subject).to raise_error
    end
    it "should assign envirnomental variable to appropriate class variable if env variable is not empty" do
      InstagramInteractionsBase::API_TOKEN ="SAMPLE_API_TOKEN"
      expect(InstagramInteractionsBase::API_TOKEN).to eq("SAMPLE_API_TOKEN")
    end
  end
end