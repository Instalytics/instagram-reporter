require 'spec_helper'

describe InstagramApiCaller do

  subject { InstagramApiCaller.new }
  let(:test_hashtag) { "inspiredby" }
  let(:test_media_file_id) { '653714645670132444_16192269' }
  let(:non_existent_media_file_id) {'669371381316733323_213058217'}

  describe '#initialize' do
    before(:all) do
      @current_token = InstagramInteractionsBase::API_TOKEN
    end

    it "should raise error if environmental variable INSTAGRAM_API_TOKEN is not set on class initialization" do
      InstagramInteractionsBase::API_TOKEN = nil
      expect { InstagramApiCaller.new }.to raise_error(ArgumentError, 'INSTAGRAM_API_TOKEN environment variable not set')
    end

    after(:all) do
      InstagramInteractionsBase::API_TOKEN = @current_token
    end
  end

  describe '#get_instagram_accounts_by_api_token' do
    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts_by_api_token') do
        expect(subject.get_instagram_accounts_by_api_token.class).to eq(Array)
      end
    end

    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts_by_api_token') do
        expect(subject.get_instagram_accounts_by_api_token.size).to eq(20)
      end
    end
  end

  describe '#get_instagram_accounts_by_access_token' do
    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts_by_access_token') do
        expect(subject.get_instagram_accounts_by_access_token('4907942.01a3945.d24a9419c2794fc987b60dcab98e22fe').class).to eq(Array)
      end
    end

    it 'returns parsed data' do
      VCR.use_cassette('get_instagram_accounts_by_access_token') do
        expect(subject.get_instagram_accounts_by_access_token('4907942.01a3945.d24a9419c2794fc987b60dcab98e22fe').size).to eq(20)
      end
    end
  end

  describe '#get_hashtag_info_by_api_token' do
    it 'returns parsed data' do
      VCR.use_cassette('get_hashtag_info_by_api_token') do
        response = subject.get_hashtag_info_by_api_token(test_hashtag)
        expect(response.class).to eq(Array)
      end
    end

    it 'returns 20 media files infos inside' do
      VCR.use_cassette('get_hashtag_info_by_api_token') do
        response = subject.get_hashtag_info_by_api_token(test_hashtag)
        expect(response.size).to eq(20)
      end
    end
  end

  describe '#get_hashtag_info_by_access_token' do
    it 'returns parsed data' do
      VCR.use_cassette('get_hashtag_info_by_access_token') do
        response = subject.get_hashtag_info_by_access_token(test_hashtag,'4907942.01a3945.d24a9419c2794fc987b60dcab98e22fe')
        expect(response.class).to eq(Array)
      end
    end

    it 'returns 20 media files infos inside' do
      VCR.use_cassette('get_hashtag_info_by_access_token') do
        response = subject.get_hashtag_info_by_access_token(test_hashtag,'4907942.01a3945.d24a9419c2794fc987b60dcab98e22fe')
        expect(response.size).to eq(20)
      end
    end
  end

  describe '#call_api_by_api_token_for_media_file_comments' do
    it 'returns parsed comments' do
      VCR.use_cassette('call_api_by_api_token_for_media_file_comments') do
        response = subject.call_api_by_api_token_for_media_file_comments(test_media_file_id)
        expect(response.class).to eq(Hash)
      end
    end

    it 'gives proper count of comments' do
      VCR.use_cassette('call_api_by_api_token_for_media_file_likes') do
        response = subject.call_api_by_api_token_for_media_file_comments(test_media_file_id)
        expect(response['count']).to eq(23)
      end
    end
  end

  describe '#call_api_by_access_token_for_media_file_comments' do
    it 'returns parsed comments' do
      VCR.use_cassette('call_api_by_access_token_for_media_file_comments') do
        response = subject.call_api_by_access_token_for_media_file_comments(test_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response.class).to eq(Hash)
      end
    end

    it 'gives proper count of comments' do
      VCR.use_cassette('call_api_by_access_token_for_media_file_likes') do
        response = subject.call_api_by_access_token_for_media_file_comments(test_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response['count']).to eq(23)
      end
    end

    it 'returns nil if called for comments for non existing media file' do
      VCR.use_cassette('call_api_by_access_token_for_non_existent_media_file_comments') do
        expected_result = {result: 'error', body: {"meta" => {"error_type" => "APINotFoundError","code" => 400,"error_message" => "invalid media id"}}}
        response = subject.call_api_by_access_token_for_media_file_comments(non_existent_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response).to eq(expected_result)
      end
    end

    xit 'returns nil if called for comments using invalid access_token' do
      VCR.use_cassette('call_api_by_non_existing_access_token_for_media_file_comments') do
        response = subject.call_api_by_access_token_for_media_file_comments(test_media_file_id,'16192269.terefere.5132ead0890d4650a196c1f33f8d0748')
        expect(response).to be(nil)
      end
    end

  end

  describe '#call_api_by_api_token_for_media_file_likes' do
    it 'returns parsed likes' do
      VCR.use_cassette('call_api_for_media_file_likes') do
        response = subject.call_api_by_api_token_for_media_file_likes(test_media_file_id)
        expect(response.class).to eq(Hash)
      end
    end

    it 'gives proper count of likes' do
      VCR.use_cassette('call_api_for_media_file_likes') do
        response = subject.call_api_by_api_token_for_media_file_likes(test_media_file_id)
        expect(response['count']).to eq(4067)
      end
    end
  end

  describe '#call_api_by_access_token_for_media_file_likes' do
    it 'returns parsed likes' do
      VCR.use_cassette('call_api_by_access_token_for_media_file_likes') do
        response = subject.call_api_by_access_token_for_media_file_likes(test_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response.class).to eq(Hash)
      end
    end

    it 'gives proper count of likes' do
      VCR.use_cassette('call_api_by_access_token_for_media_file_likes') do
        response = subject.call_api_by_access_token_for_media_file_likes(test_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response['count']).to eq(4067)
      end
    end

    it 'returns nil if called for likes for non existing media file' do
      VCR.use_cassette('call_api_by_access_token_for_non_existent_media_file_likes') do
        expected_result = {result: 'error', body: {"meta" => {"error_type" => "APINotFoundError","code" => 400,"error_message" => "invalid media id"}}}
        response = subject.call_api_by_access_token_for_media_file_likes(non_existent_media_file_id,'16192269.01a3945.5132ead0890d4650a196c1f33f8d0748')
        expect(response).to eq(expected_result)
      end
    end

    xit 'returns nil if called for likes with invalid access token' do
      VCR.use_cassette('call_api_by_non_existing_access_token_for_media_file_likes') do
        response = subject.call_api_by_access_token_for_media_file_likes(test_media_file_id,'16192269.terefere.5132ead0890d4650a196c1f33f8d0748')
        expect(response).to be(nil)
      end
    end

  end
end
