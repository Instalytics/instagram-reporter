# encoding: UTF-8

class InstagramApiCaller < InstagramInteractionsBase

  attr_accessor :api_connection

  def initialize
    @api_connection = Faraday.new(url: API_BASE_URL) do |faraday|
      faraday.request  :url_encoded
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_instagram_accounts
    response = @api_connection.get do |req|
      req.url "#{POPULAR_INSTAGRAM_MEDIA_URL}?client_id=#{API_TOKEN}"
      req.options = DEFAULT_REQUEST_OPTIONS
    end

    parse_json(response.body)
  end

  def get_hashtag_info(tag)
    response = @faraday_connection.get do |req|
      req.url "/v1/tags/#{tag}/media/recent?client_id=#{TOKENS.shuffle.first}"
      req.options = { timeout: 15, open_timeout: 15}
    end

    parse_json(response.body)
  end


  private
    def parse_json(data)
      Oj.load(data)['data']
    end
end
