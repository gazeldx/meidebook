class User < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :username
  end
end
