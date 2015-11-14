class User < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence :username
  end
end
