require 'spec_helper'

describe InstagramWebsiteCaller do

  describe '#initialize' do
    it 'has proper Faraday connection object' do
      expect(subject.website_connection.class).to be(Faraday::Connection)
    end
  end

  describe '#get_profile_page' do
    it 'returns website' do
      VCR.use_cassette('get_profile_page') do
        expect(subject.get_profile_page('luki3k5')).not_to be(nil)
      end
    end
  end
end
