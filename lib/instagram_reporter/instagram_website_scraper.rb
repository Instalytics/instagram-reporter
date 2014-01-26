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
    doc.css('script').each do |k|
      begin
        JSON.parse(k.content.match(/\[{"componentName".*}\]/).to_s).each do |el|
          returnee = el['props']['user']
          returnee['contact_data_email']  = contact_data_email(returnee['bio'])
          returnee['other_contact_means'] = find_other_contact_means(returnee['bio'])
        end
      rescue
      end
    end
    returnee
  end

  def get_likes_and_comments(html, media_file_id)
    returnee = nil
    doc = Nokogiri::HTML(html)
    likes = doc.content.scan(/"likes":\{"count":[0-9]+(?:\.[0-9]*)?/)
    comments = doc.content.scan(/"comments":\{"count":[0-9]+(?:\.[0-9]*)?/)
    media_ids = doc.content.scan(/"id":"\d*_\d*"/)

    media_ids.each_with_index do |media_id, index|
      if media_id.match(/\d+_\d+/).to_s == media_file_id
        like = likes[index].match(/\d+/).to_s
        comment = comments[index].match(/\d+/).to_s  
        returnee = {"likes_count" => like, "comments_count" => comment}
      end
    end
    returnee 
  end

  def get_profile_statistic(html)
    doc = Nokogiri::HTML(html)
    returnee = eval(doc.content.match(/{"media":.*\d}/).to_s.gsub(":","=>"))
    return returnee
  end
end
