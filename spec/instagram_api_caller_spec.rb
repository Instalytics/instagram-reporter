require 'spec_helper'

describe InstagramApiCaller do

  subject { InstagramApiCaller.new }

  describe '#initialize' do
    it 'has proper Faraday connection object' do
      expect(subject.api_connection.class).to be(Faraday::Connection)
    end
  end

  describe '#get_data' do
    it 'returns parsed hash' do
      VCR.use_cassette('get_instagram_accounts') do
        expect(subject.get_instagram_accounts.class).to eq(Array)
      end
    end
  end

end
