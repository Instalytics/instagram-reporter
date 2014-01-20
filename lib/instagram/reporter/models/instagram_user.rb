class InstagramUser
  include Mongoid::Document

  validates :username, uniqueness: true

  field :username,          type: String
  field :email,             type: String
  field :followers,         type: String
  field :bio,               type: String
  field :created_at,        type: DateTime
  field :updated_at,        type: DateTime
  field :already_presented, type: Boolean

  scope :with_email,     nin(email: [nil, ""])
  scope :with_followers, nin(followers: [nil, ""])
  scope :last_24h,       where(:created_at.gt => 1.day.ago)
  scope :last_3_days,    where(:created_at.gt => 3.days.ago).where(:created_at.lt => 1.day.ago)
  scope :last_7_days,    where(:created_at.gt => 7.days.ago).where(:created_at.lt => 1.day.ago)

  def formated_created_at
    self.created_at.strftime('%d-%m-%Y (%H:%M)')
  end

end
