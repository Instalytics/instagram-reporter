# encoding: UTF-8

class InstagramApiCaller < InstagramInteractionsBase

  def get_instagram_accounts_by_api_token
    uri = "#{API_BASE_URL}#{POPULAR_INSTAGRAM_MEDIA_URL}?#{query_params(nil)}"
    instagram_api_get_and_parse(uri)
  end

  def get_instagram_accounts_by_access_token(access_token)
    uri = "#{API_BASE_URL}#{POPULAR_INSTAGRAM_MEDIA_URL}?#{query_params(access_token)}"
    instagram_api_get_and_parse(uri)
  end

  def get_hashtag_info_by_access_token(tag, access_token, min_id = nil)
    uri = "#{API_BASE_URL}/v1/tags/#{tag}/media/recent?#{query_params(access_token)}"
    uri = "/v1/tags/#{tag}/media/recent?min_id=#{min_id}&#{query_params(access_token)}" if !min_id.nil?
    instagram_api_get_and_parse(uri, true)
  end

  def get_hashtag_info_by_api_token(tag, min_id = nil)
    uri = "#{API_BASE_URL}/v1/tags/#{tag}/media/recent?#{query_params(nil)}"
    uri = "/v1/tags/#{tag}/media/recent?min_id=#{min_id}&#{query_params(nil)}" if !min_id.nil?
    instagram_api_get_and_parse(uri, true)
  end

  def user_recent_media(user_id, access_token)
    uri = "#{API_BASE_URL}/v1/users/#{user_id}/media/recent?#{query_params(access_token)}"
    instagram_api_get_and_parse(uri, true)
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

    def parse_json(data)
      Oj.load(data)['data']
    end

    def get_pagination(data)
      Oj.load(data)['pagination']
    end

    def instagram_api_get_and_parse(uri, get_pagination = false)
      response = Hash.new
  
      api_response = api_connection.get do |req|
        req.url "#{uri}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end

      if(api_response.status == 200)
        response['data']       = parse_response(api_response, uri)
        response['pagination'] = get_pagination(api_response.body) if get_pagination
        response['result']     = 'ok'
        response['status']     = api_response.status
      else
        response = parse_response(api_response, uri)
      end

      return response

    end

    def parse_response(response, uri)
      case response.status
      when 200
        parse_json(response.body)
      when 400, 404, 500, 502, 503, 504
        {
          result: 'error',
          body: response.body,
          status: response.status,
          url: uri
        }
      else
        raise "unsupported response status during GET #{uri}: #{response.status}. response body : #{response.body} "
      end
    end

    def query_params(access_token)
      access_token ? "access_token=#{access_token}"  : "client_id=#{API_TOKEN}"
    end

    def call_api_by_access_token_for_media_info(instagram_media_id, access_token , action)
      response = api_connection.get do |req|
        req.url "/v1/media/#{instagram_media_id}?access_token=#{access_token}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      if response.status == 200
        resp_json = parse_json(response.body)
        return {result: 'ok'}.merge(resp_json[action])
      elsif  response.status == 400
        return {result: 'error', body: Oj.load(response.body)}
      else
        raise "call for media #{action} (media_id: #{instagram_media_id}) failed with response #{response.inspect}"
      end
    end

    def call_api_by_api_token_for_media_file(media_id, action)
      response = api_connection.get do |req|
        req.url "/v1/media/#{media_id}?client_id=#{API_TOKEN}"
        req.options = DEFAULT_REQUEST_OPTIONS
      end
      if response.status == 200
        resp_json = parse_json(response.body)
        return {result: 'ok'}.merge(resp_json[action])
      elsif  response.status == 400
        return {result: 'error', body: Oj.load(response.body)}
      else
        raise "call for media #{action} (media_id: #{media_id}) failed with response #{response.inspect}"
      end
    end

    def api_connection
      @api_connection ||= Faraday.new(url: API_BASE_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.use FaradayMiddleware::FollowRedirects
        faraday.adapter  Faraday.default_adapter
      end
    end
end
