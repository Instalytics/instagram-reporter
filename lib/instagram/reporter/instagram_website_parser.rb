class InstagramWebsiteDataParser

  SEARCHABLE_KEYWORDS = %w(contact business Business Facebook facebook fb email Twitter twitter Contact FB tumblr Blog blog mail http www)
  EMAIL_PATTERN_MATCH = /([^@\s*]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i

  def contact_data_email(data)
    _.to_s if data.match(EMAIL_PATTERN_MATCH) != nil
  end

  def contact_data(data)
    return data.gsub(',', '') if data.match(EMAIL_PATTERN_MATCH) != nil

    SEARCHABLE_KEYWORDS.each do |ci|
      return data.gsub(',', '') if data.include?(ci)
    end
    return nil
  end

  def parse_followers_for_account(html)
    returnee = nil
    doc = Nokogiri::HTML(html)
    doc.css('script').each do |k|
      begin
        JSON.parse(k.content.match(/\[{"componentName".*}\]/).to_s).each do |el|
          returnee = el['props']['user']
        end
      rescue
        puts 'skipping not the right <script> tag'
      end
    end
    returnee
  end

end
