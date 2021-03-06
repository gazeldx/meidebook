class Comment < Sequel::Model
  many_to_one :book

  mount_uploader :photo, PhotoUploader

  plugin :validation_helpers

  def validate
    super
    validates_presence :book_id
    errors.add(:photo, I18n.t('comment.extension_invalid')) if body.blank? && photo.blank?
  end
end
