class Comment < Sequel::Model
  plugin :validation_helpers

  mount_uploader :photo, PhotoUploader

  def validate
    super
    validates_presence :book_id
  end
end
