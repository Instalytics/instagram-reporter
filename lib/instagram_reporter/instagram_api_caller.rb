# encoding: UTF-8

class InstagramApiCaller < InstagramInteractionsBase

  attr_accessor :api_connection

  def initialize
    super
    @api_connection = Faraday.new(url: API_BASE_URL) do |faraday|
      faraday.request  :url_encoded
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_instagram_accounts_by_api_token
    begin
      response = @api_connection.get do |req|
        req.url "#{POPULAR_INSTAGRAM_MEDIA_URL}?client_id=#{API_TOKEN}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      return parse_json(response.body)
    rescue Exception => ex
      raise ex
    end
  end

  def get_instagram_accounts_by_access_token(access_token) 
    begin
      response = @api_connection.get do |req|
        req.url "#{POPULAR_INSTAGRAM_MEDIA_URL}?access_token=#{access_token}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      return parse_json(response.body)
    rescue Exception => ex
      raise ex
    end
  end

  def get_hashtag_info_by_access_token(tag,access_token)
    begin
      response = @api_connection.get do |req|
        req.url "/v1/tags/#{tag}/media/recent?access_token=#{access_token}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      return parse_json(response.body)
    rescue Exception => ex
      raise ex
    end
  end

  def get_hashtag_info_by_api_token(tag)
    begin
      response = @api_connection.get do |req|
        req.url "/v1/tags/#{tag}/media/recent?client_id=#{API_TOKEN}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      return parse_json(response.body)
    rescue Exception => ex
      raise ex
    end
  end

  def call_api_by_access_token_for_media_file_comments(instagram_media_id,access_token)
    call_api_by_access_token_for_media_file(instagram_media_id, access_token, 'comments')
  end

  def call_api_by_access_token_for_media_file_likes(instagram_media_id, access_token)
    call_api_by_access_token_for_media_file(instagram_media_id, access_token, 'likes')
  end

  def call_api_by_api_token_for_media_file_comments(instagram_media_id)
    call_api_by_api_token_for_media_file(instagram_media_id, 'comments')
  end

  def call_api_by_api_token_for_media_file_likes(instagram_media_id)
    call_api_by_api_token_for_media_file(instagram_media_id, 'likes')
  end


  private
    def parse_json(data)
      Oj.load(data)['data']
    end

    def call_api_by_api_token_for_media_file(media_id, action)
      response = @api_connection.get do |req|
        req.url "/v1/media/#{media_id}/#{action}?client_id=#{API_TOKEN}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end

      if response.status == 200
        return parse_json(response.body)
      else
        raise 'call for media failed'
      end
    end

    def call_api_by_access_token_for_media_file(media_id, access_token, action)
      response = @api_connection.get do |req|
        req.url "/v1/media/#{media_id}/#{action}?access_token=#{access_token}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end

      if response.status == 200
        return parse_json(response.body)
      else
        raise 'call for media failed'
      end
    end
end
