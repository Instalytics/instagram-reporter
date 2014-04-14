# encoding: UTF-8

class InstagramApiCaller < InstagramInteractionsBase

  def initialize
    super
    @api_connection = Faraday.new(url: API_BASE_URL) do |faraday|
      faraday.request  :url_encoded
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_instagram_accounts_by_api_token
    instagram_api_get_and_parse(POPULAR_INSTAGRAM_MEDIA_URL)
  end

  def get_instagram_accounts_by_access_token(access_token) 
    instagram_api_get_and_parse(POPULAR_INSTAGRAM_MEDIA_URL, access_token)
  end

  def get_hashtag_info_by_access_token(tag, access_token)
    instagram_api_get_and_parse("/v1/tags/#{tag}/media/recent", access_token)
  end

  def get_hashtag_info_by_api_token(tag)
    instagram_api_get_and_parse("/v1/tags/#{tag}/media/recent")
  end

  def call_api_by_access_token_for_media_file_comments(instagram_media_id,access_token)
    call_api_by_access_token_for_media_info(instagram_media_id, access_token, 'comments')
  end

  def call_api_by_access_token_for_media_file_likes(instagram_media_id, access_token)
    call_api_by_access_token_for_media_info(instagram_media_id, access_token, 'likes')
  end

  def call_api_by_api_token_for_media_file_comments(instagram_media_id)
    call_api_by_api_token_for_media_file(instagram_media_id, 'comments')
  end

  def call_api_by_api_token_for_media_file_likes(instagram_media_id)
    call_api_by_api_token_for_media_file(instagram_media_id, 'likes')
  end

  private
    attr_reader :api_connection

    def parse_json(data)
      Oj.load(data)['data']
    end

    def instagram_api_get_and_parse(url, access_token = nil)
      response = api_connection.get do |req|
        req.url "#{url}?#{query_params(access_token)}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      parse_response(response)
    end

    def parse_response(response)
      case response.status
      when 200
        parse_json(response.body)
      when 404, 500, 502, 503, 504
        {
          result: 'error',
          body: response.body,
          status: response.status
        }
      end
    rescue Exception => ex
      raise ex, "Failed to obtain instagram data for url #{url} #{ex.inspect}. response body is : #{response.inspect}"
    end

    def query_params(access_token)
      access_token ? "access_token=#{access_token}"  : "client_id=#{API_TOKEN}"
    end

    def call_api_by_access_token_for_media_info(instagram_media_id, access_token , action)
      response = @api_connection.get do |req|
        req.url "/v1/media/#{instagram_media_id}?access_token=#{access_token}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      if response.status == 200
        resp_json = {result: 'ok'}.merge(parse_json(response.body))
        return resp_json[action]
      elsif  response.status == 400
        return {result: 'error', body: Oj.load(response.body)}
      else
        raise "call for media #{action} (media_id: #{instagram_media_id}) failed with response #{response.inspect}"
      end
    end

    def call_api_by_api_token_for_media_file(media_id, action)
      response = @api_connection.get do |req|
        req.url "/v1/media/#{media_id}?client_id=#{API_TOKEN}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      if response.status == 200
        resp_json = parse_json(response.body)
        return resp_json[action]
      elsif  response.status == 400
        return {result: 'error', body: Oj.load(response.body)}
      else
        raise "call for media #{action} (media_id: #{media_id}) failed with response #{response.inspect}"
      end
    end
end
