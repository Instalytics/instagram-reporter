require 'spec_helper'

describe InstagramPopularAccountsFinder do

  subject { InstagramPopularAccountsFinder.new }

  describe '#initialize' do
    it 'has proper Faraday connection object' do
      expect(subject.connection).not_to be(nil)
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
