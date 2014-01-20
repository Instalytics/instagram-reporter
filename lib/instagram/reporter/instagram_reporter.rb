require "instagram/reporter/version"
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
require 'instagram_interactions_base'
require 'instagram_api_caller'
require 'instagram_website_caller'
require 'instagram_website_parser'

# MODELS
require 'models/instagram_user'
require 'models/instagram_media_file'
require 'models/instagram_media_file_probe'

module Instagram
  class InstagramReporter
<<<<<<< HEAD
    
    def intialize
      if ENV['MONGOHQ_URL'].empty?
        raise "Please configure database connection URI under MONGOHQ_URL environmental variable"
      else
        #check if environmental variables are set for mongoid 
        connection = Mongo::Connection.new(ENV['MONGOHQ_URL'])
        MongoConfig.connection = connection
      end
=======

    def initialize
      # check me for having the vars setup
>>>>>>> beab8ba2a08f0b7862d67941e30b1c55abfccce6
    end

    def get_all_popular_instagram_accounts
      instagram_accounts = InstagramApiCaller.new.get_instagram_accounts
      #puts
      #puts 'getting new users from instagram'
      #puts
      #instagram_accounts.each do |u|
      #usr_name = u['user']['username']
      #InstagramWebsiteParser.new.get_followers_number(usr_name)
      #end
    end
  end
end
