class InstagramInteractionsBase
  attr_accessor :mongoid_config

  API_BASE_URL = 'https://api.instagram.com'
  WEB_BASE_URL = 'http://instagram.com'
  TOKENS       = ENV['INSTAGRAM_API_TOKEN']
end
