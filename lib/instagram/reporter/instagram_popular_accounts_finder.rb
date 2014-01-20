# encoding: UTF-8

class InstagramPopularAccountsFinder < InstagramInteractionsBase

  attr_accessor :connection

  #FOLLOWERS_LIMIT = 10

  def initialize
    #@mongoid_config = Rails.root.join("config", "mongoid.yml").to_s

    @connection = Faraday.new(url: API_BASE_URL) do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

  end

  def get_instagram_accounts
    response = @connection.get do |req|
      req.url "#{POPULAR_INSTAGRAM_MEDIA_URL}?client_id=#{API_TOKEN}"
      req.options = DEFAULT_REQUEST_OPTIONS
    end

    JSON.parse(response.body)['data']
  end

end
