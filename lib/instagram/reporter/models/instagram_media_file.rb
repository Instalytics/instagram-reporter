class InstagramMediaFile
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :instagram_media_id, uniqueness: true

  field :instagram_username,   type: String
  field :instagram_media_id,   type: String
  field :instagram_type,       type: String
  field :instagram_link,       type: String
  field :for_observed_ig_tag,  type: String
  field :instagram_created_at, type: DateTime

  has_many   :instagram_media_file_probes
  belongs_to :instagram_user
end
