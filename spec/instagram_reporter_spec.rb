require 'spec_helper'

describe InstagramReporter do 

  describe "#initialize" do
    
    it "has proper instagram api caller set" do
      expect(subject.instagram_api_caller.class).to be(InstagramApiCaller)
    end
    
    it "has proper instagram website caller set" do
      expect(subject.instagram_website_caller.class).to be(InstagramWebsiteCaller)
    end
    
    it "has proper instagram website scraper set" do
      expect(subject.instagram_website_data_parser.class).to be(InstagramWebsiteScraper)
    end

  end

  
end