require 'spec_helper'

describe InstagramWebCaller do

  describe '#get_profile_page' do
    it 'returns website' do
      VCR.use_cassette('get_profile_page') do
        expect(subject.get_profile_page('luki3k5')).not_to be(nil)
      end
    end
  end
end
