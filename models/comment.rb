class Comment < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :book_id
  end
end
