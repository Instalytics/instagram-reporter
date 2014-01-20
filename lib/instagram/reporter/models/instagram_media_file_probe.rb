class InstagramMediaFileProbe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :likes,    type: Integer
  field :comments, type: Integer

  belongs_to :instagram_media_file
end
