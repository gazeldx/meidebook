class Post < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence     :body
    validates_presence     :user_id
  end
end
