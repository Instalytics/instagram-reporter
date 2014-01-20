# encoding: UTF-8
#
class InstagramWebCaller < InstagramInteractionsBase
  attr_accessor :website_connection

  def initialize
    @website_connection = Faraday.new(url: WEB_BASE_URL) do |faraday|
      faraday.request  :url_encoded
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_profile_page(account_name)
    @website_connection.get("/#{account_name}").body
  end
end
