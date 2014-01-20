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

    JSON.parse(response.body)['data']
  end



    #i = InstagramUser.create({
      #username:          returnee['username'],
      #email:             contact_data_email(returnee['bio']),
      #followers:         returnee['counts']['followed_by'].to_i / 1000,
      #bio:               contact_data(returnee['bio']),
      #created_at:        DateTime.now,
      #updated_at:        DateTime.now,
      #already_presented: false
    #})
    #print "." if i.valid?

end
