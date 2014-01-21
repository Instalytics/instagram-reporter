require 'spec_helper'

describe InstagramApiCaller do

  subject { InstagramApiCaller.new }
  let(:test_hashtag) { "inspiredby" }

  describe '#initialize' do
    it 'has proper Faraday connection object' do
      expect(subject.api_connection.class).to be(Faraday::Connection)
    end
  end

  describe '#get_instagram_accounts' do
    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts') do
        expect(subject.get_instagram_accounts.class).to eq(Array)
      end
    end

    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts') do
        expect(subject.get_instagram_accounts.size).to eq(16)
      end
    end
  end

  describe '#get_hashtag_info' do
    it 'returns parsed data' do
      VCR.use_cassette('get_hashtag_info') do
        response = subject.get_hashtag_info(test_hashtag)
        expect(response.class).to eq(Array)
      end
    end

    it 'returns 20 media files infos inside' do
      VCR.use_cassette('get_hashtag_info') do
        response = subject.get_hashtag_info(test_hashtag)
        expect(response.size).to eq(20)
      end
    end
  end

end
