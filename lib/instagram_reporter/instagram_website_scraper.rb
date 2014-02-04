class InstagramWebsiteScraper

  SEARCHABLE_KEYWORDS = %w(contact business Business Facebook facebook fb email Twitter twitter Contact FB tumblr Blog blog mail http www)
  EMAIL_PATTERN_MATCH = /([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i

  def contact_data_email(data)
    matched = data.match(EMAIL_PATTERN_MATCH)
    return matched.to_s if matched != nil
    nil
  end

  def find_other_contact_means(data)
    return data.gsub(',', '') if data.match(EMAIL_PATTERN_MATCH) != nil

    SEARCHABLE_KEYWORDS.each do |ci|
      return data.gsub(',', '') if data.include?(ci)
    end
    return nil
  end

  def scrape_data_for_profile_page(html)
    returnee = nil
    doc = Nokogiri::HTML(html)
    el = JSON.parse(doc.content.match(/{"entry_data":{.*}/).to_s)
    returnee = el['entry_data']['UserProfile'][0]['user']
    returnee['contact_data_email']  = contact_data_email(returnee['bio'])
    returnee['other_contact_means'] = find_other_contact_means(returnee['bio'])
    returnee
  end

  def get_likes_and_comments(html)
    returnee        = {status: 'online'}
    doc              = Nokogiri::HTML(html)
    likes_content    = doc.content.match(/"likes":\{"count":[0-9]+(?:\.[0-9]*)?/).to_s
    likes            = likes_content.match(/[0-9][0-9]*/).to_s
    comments_content = doc.content.match(/"comments":{"nodes":\[.*?\]}/).to_s
    comments        = comments_content.scan(/"id":"[0-9]*"/)
    return nil if likes.nil? || comments.nil?
    # instagram media file removed
    returnee.merge!({status: 'offline'}) if !doc.content.match(/Page Not Found/).nil?
    returnee.merge!({likes_count: likes, comments_count: comments.size.to_s})
  end

  def get_profile_statistic(html)
    doc = Nokogiri::HTML(html)
    returnee = eval(doc.content.match(/{"media":.*\d}/).to_s.gsub(":","=>"))
    return returnee
  end
end
