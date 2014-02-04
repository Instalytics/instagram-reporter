require 'spec_helper'

describe InstagramApiCaller do

  subject { InstagramApiCaller.new }
  let(:test_hashtag) { "inspiredby" }
  let(:test_media_file_id) { '637637553239091125_432464344' }

  describe '#initialize' do
    before(:all) do
      @current_token = InstagramInteractionsBase::API_TOKEN
    end

    it 'has proper Faraday connection object' do
      expect(subject.api_connection.class).to be(Faraday::Connection)
    end

    it "should raise error if environmental variable INSTAGRAM_API_TOKEN is not set on class initialization" do
      InstagramInteractionsBase::API_TOKEN = nil
      expect { InstagramApiCaller.new }.to raise_error(RuntimeError, 'INSTAGRAM_API_TOKEN environment variable not set')
    end

    after(:all) do
      InstagramInteractionsBase::API_TOKEN = @current_token
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
        expect(subject.get_instagram_accounts.size).to eq(20)
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

  describe '#call_api_for_media_file_comments' do
    it 'returns parsed comments' do
      VCR.use_cassette('call_api_for_media_file_comments') do
        response = subject.call_api_for_media_file_comments(test_media_file_id)
        expect(response.class).to eq(Array)
      end
    end

    it 'gives proper count of comments' do
      VCR.use_cassette('call_api_for_media_file_likes') do
        response = subject.call_api_for_media_file_comments(test_media_file_id)
        expect(response.count).to eq(4)
      end
    end
  end

  describe '#call_api_for_media_file_likes' do
    it 'returns parsed likes' do
      VCR.use_cassette('call_api_for_media_file_likes') do
        response = subject.call_api_for_media_file_likes(test_media_file_id)
        expect(response.class).to eq(Array)
      end
    end

    it 'gives proper count of likes' do
      VCR.use_cassette('call_api_for_media_file_likes') do
        response = subject.call_api_for_media_file_likes(test_media_file_id)
        expect(response.count).to eq(120)
      end
    end
  end
end
