# This is the 'Probe' meaning we create these in
# certain intervals to keep track of changes of number comments and likes
#
class InstagramMediaFileProbe
  include Mongoid::Document
  include Mongoid::Timestamps

  field :likes,    type: Integer
  field :comments, type: Integer

  belongs_to :instagram_media_file
end
