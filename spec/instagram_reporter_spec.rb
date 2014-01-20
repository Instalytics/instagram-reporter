require 'spec_helper'

describe InstagramReporter do 

  describe "#initialize" do
    xit "has proper instagram api caller set" do
      expect(subject.instagram_api_caller.class).to be(InstagramApiCaller)
    end

    xit "has proper instagram website caller set" do
      expect(subject.instagram_website_caller.class).to be(InstagramWebsiteCaller)
    end

    xit "has proper instagram website scraper set" do
      expect(subject.instagram_website_data_parser.class).to be(InstagramWebsiteScraper)
    end
  end
end
