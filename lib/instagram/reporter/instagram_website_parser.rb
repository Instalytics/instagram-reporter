
class InstagramWebsiteDataParser
  SEARCHABLE_KEYWORDS = %w(contact business Business Facebook facebook fb email Twitter twitter Contact FB tumblr Blog blog mail http www)

  def contact_data_email(data)
    if data.match(/([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i) != nil ? true : false
      return data.match(/([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i).to_s
    end
  end

  def contact_data(data)
    if data.match(/([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i) != nil ? true : false
      return data.gsub(',', '')
    end

    SEARCHABLE_KEYWORDS.each do |ci|
      return data.gsub(',', '') if data.include?(ci)
    end
    return nil
  end

  def get_followers_number(follower_name)
    returnee = nil
    conn = Faraday.new(:url => "https://instagram.com" ) do |faraday|
      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter :net_http
    end

    response = conn.get "/#{follower_name}"

    doc = Nokogiri::HTML(response.body)
    doc.css('script').each do |k|
      begin
        JSON.parse(k.content.match(/\[{"componentName".*}\]/).to_s).each do |el|
          returnee = el['props']['user']
        end
      rescue
        puts 'skipping not the right <script> tag'
      end
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
end
