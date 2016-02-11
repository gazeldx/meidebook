class Post < Sequel::Model
  many_to_one :user

  plugin :validation_helpers

  def validate
    super
    validates_presence :body
    validates_presence :user_id
  end
end
