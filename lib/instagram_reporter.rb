require "instagram-reporter/version"
require 'rubygems'

# DEPENDENCIES
require 'faraday'
require 'faraday_middleware'
require 'json'
require 'capybara'
require 'capybara/dsl'
require 'nokogiri'
require 'open-uri'
require 'mongoid'

# MAIN FILES
require 'instagram-reporter/instagram_interactions_base'
require 'instagram-reporter/instagram_api_caller'
require 'instagram-reporter/instagram_website_caller'
require 'instagram-reporter/instagram_website_scraper'

class InstagramReporter

  attr_accessor :instagram_api_caller, :instagram_website_caller, :instagram_website_data_parser

  def initialize
    @instagram_api_caller          = InstagramApiCaller.new
    @instagram_website_caller      = InstagramWebsiteCaller.new
    @instagram_website_data_parser = InstagramWebsiteScraper.new
  end

  def get_popular_instagram_accounts
    instagram_api_caller.get_instagram_accounts.each do |u|
      username     = u['user']['username']
      profile_page = instagram_website_caller.get_profile_page(username)
      instagram_website_data_parser.scrape_data_for_profile_page(profile_page)

      #i = InstagramUser.create({ # TODO FIXME consider moving this away!
      #username:          scraped_data['username'],
      #email:             scraped_data['contact_data_email'],
      #followers:         scraped_data['counts']['followed_by'].to_i / 1000,
      #bio:               scraped_data['other_contact_means'],
      #created_at:        DateTime.now,
      #updated_at:        DateTime.now,
      #already_presented: false
      #})
      #print "." if i.valid?
    end

  end
end
