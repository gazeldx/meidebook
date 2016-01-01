class Comment < Sequel::Model
  many_to_one :book

  mount_uploader :photo, PhotoUploader

  plugin :validation_helpers

  def validate
    super
    validates_presence :book_id
  end
end
