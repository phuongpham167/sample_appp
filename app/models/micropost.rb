class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  private

    def picture_size
      if picture.size > (Settings.micropost.picture_size).megabytes
        errors.add :picture, t(".danger_lenght")
      end
    end
end